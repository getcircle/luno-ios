//
//  GroupDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 5/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry
import MBProgressHUD

class GroupDetailViewController: DetailViewController, 
    CardHeaderViewDelegate,
    ProfileSelectorDelegate
{

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        dataSource = GroupDetailDataSource()
        delegate = CardCollectionViewDelegate()
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavButtons()
    }
    
    // MARK: - Configuration

    private func configureNavButtons() {
        addAddButtonWithAction("addGroupMemberButtonTapped:")
    }

    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        dataSource.cardHeaderDelegate = self
        
        // Delegate
        collectionView.delegate = delegate
        
        (layout as! StickyHeaderCollectionViewLayout).headerHeight = GroupHeaderCollectionReusableView.height
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let card = dataSource.cardAtSection(indexPath.section), content: AnyObject = dataSource.contentAtIndexPath(indexPath) {
            switch card.type {
            case .Settings:
                if let contentTypeValue = content["type"] as? Int, contentType = ContentType(rawValue: contentTypeValue) {
                    handleGroupMembershipActions(contentType)
                }
                break
                
                
            case .Profiles:
                if let profile = content as? Services.Profile.Containers.ProfileV1 {
                    let profileVC = ProfileDetailViewController(profile: profile)
                    navigationController?.pushViewController(profileVC, animated: true)
                }
                
            case .KeyValue:
                // Assumption: KeyValue here will only be an email value
                presentMailViewController(
                    [(dataSource as! GroupDetailDataSource).selectedGroup.email], 
                    subject: "", 
                    messageBody: "", 
                    completionHandler: nil
                )
                
            default:
                break
            }
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let groupHeaderView = (collectionView!.dataSource as! GroupDetailDataSource).groupHeaderView {
            let contentOffset = scrollView.contentOffset
            
            // Todo: need to understand how this changes with orientation
            let statusBarHeight: CGFloat = currentStatusBarHeight()
            let navBarHeight: CGFloat = navigationBarHeight()
            let navBarStatusBarHeight: CGFloat = navBarHeight + statusBarHeight
            let initialYConstrainValue: CGFloat = groupHeaderView.groupNameLabelCenterYConstraintInitialValue
            let finalYConstraintValue: CGFloat = groupHeaderView.frame.height/2.0 - navBarHeight/2.0
            // Initial y value is added because for center y constraints this represents additional distance it needs
            // to move down
            let distanceToMove: CGFloat = finalYConstraintValue + initialYConstrainValue
            let pointAtWhichFinalHeightShouldBeInPlace: CGFloat = GroupHeaderCollectionReusableView.height - navBarStatusBarHeight
            let pointAtWhichHeightShouldStartIncreasing: CGFloat = pointAtWhichFinalHeightShouldBeInPlace - distanceToMove
            
            // Y Constraint has to be modified only after a certain point
            if contentOffset.y > pointAtWhichHeightShouldStartIncreasing {
                var newY: CGFloat = initialYConstrainValue
                newY += max(-distanceToMove, -contentOffset.y + pointAtWhichHeightShouldStartIncreasing)
                groupHeaderView.groupNameLabelCenterYConstraint.constant = newY
            }
            else {
                groupHeaderView.groupNameLabelCenterYConstraint.constant = initialYConstrainValue
            }
            
            let minFontSize: CGFloat = 15.0
            let maxFontSize: CGFloat = groupHeaderView.groupNameLabelInitialFontSize
            let pointAtWhichSizeShouldStartChanging: CGFloat = 20.0
            
            // Size needs to be modified much sooner
            if contentOffset.y > pointAtWhichSizeShouldStartChanging {
                var size = max(minFontSize, maxFontSize - ((contentOffset.y - pointAtWhichSizeShouldStartChanging) / (maxFontSize - minFontSize)))
                groupHeaderView.groupNameLabel.font = UIFont(name: groupHeaderView.groupNameLabel.font.familyName, size: size)
            }
            else {
                groupHeaderView.groupNameLabel.font = UIFont(name: groupHeaderView.groupNameLabel.font.familyName, size: maxFontSize)
            }
            
            // Modify alpha for departmentlabel
            if contentOffset.y > 0.0 {
                groupHeaderView.groupSecondaryInfoLabel.alpha = 1.0 - contentOffset.y/(groupHeaderView.groupSecondaryInfoLabel.frame.origin.y - 40.0)
            }
            else {
                groupHeaderView.groupSecondaryInfoLabel.alpha = 1.0
            }
            
            // Update constraints and request layout
            groupHeaderView.groupNameLabel.setNeedsUpdateConstraints()
            groupHeaderView.groupNameLabel.layoutIfNeeded()
        }
    }
    
    // MARK: - CardHeaderViewDelegate
    
    func cardHeaderTapped(sender: AnyObject!, card: Card!) {
        let viewController = ProfilesViewController()
        if let dataSource = dataSource as? GroupDetailDataSource {
            
            let nextRequest = card.title == AppStrings.GroupManagersSectionTitle ? dataSource.nextManagerMembersRequest : dataSource.nextMembersRequest
            let groupRole: Services.Group.Containers.RoleV1 = card.title == AppStrings.GroupManagersSectionTitle ? .Manager : .Member
            (viewController.dataSource as! ProfilesDataSource).configureForGroup(dataSource.selectedGroup, role: groupRole)
            viewController.dataSource.setInitialData(
                content: card.allContent,
                ofType: nil,
                nextRequest: nextRequest
            )
            
            viewController.title = card.title
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - Tracking
    
    func trackCardHeaderTapped(card: Card, overviewType: TrackerProperty.OverviewType) {
        let properties = [
            TrackerProperty.withKeyString("card_type").withString(card.type.rawValue),
            TrackerProperty.withKey(.Source).withSource(.Detail),
            TrackerProperty.withKey(.SourceDetailType).withDetailType(.Office),
            TrackerProperty.withKey(.Destination).withSource(.Overview),
            TrackerProperty.withKey(.DestinationOverviewType).withOverviewType(overviewType),
            TrackerProperty.withKeyString("card_title").withString(card.title),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description())
        ]
        Tracker.sharedInstance.track(.CardHeaderTapped, properties: properties)
    }
    
    // MARK: - IBActions
    
    @IBAction func addGroupMemberButtonTapped(sender: AnyObject!) {
        // TODO: Check if this user is a manager
        let profilesSelectorViewController = ProfilesSelectorViewController()
        // Don't add the default search/filter textfield...instead VC adds a token field
        profilesSelectorViewController.addSearchFilterView = false
        profilesSelectorViewController.profileSelectorDelegate = self
        profilesSelectorViewController.title = AppStrings.GroupAddMembersNavTitle
        let addMemberNavController = UINavigationController(rootViewController: profilesSelectorViewController)
        navigationController?.presentViewController(addMemberNavController, animated: true, completion: nil)

    }
    
    // MARK: - ProfilesSelectorDelegate
    
    func onSelectedProfiles(profiles: Array<Services.Profile.Containers.ProfileV1>) -> Bool {
        if let presentedViewController = presentedViewController {
            
            let dataSource = (self.dataSource as! GroupDetailDataSource)
            let hud = MBProgressHUD.showHUDAddedTo(presentedViewController.view, animated: true)
            Services.Group.Actions.addMembers(
                dataSource.selectedGroup.email,
                profiles: profiles, 
                completionHandler: { (newMembers, error) -> Void in
                    hud.hide(true)

                    if error == nil {
                        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
                        self.updateGroup()
                    }
            })
        }
        return false
    }
    
    // MARK: - Helpers

    private func handleGroupMembershipActions(actionType: ContentType) {
        let dataSource = (self.dataSource as! GroupDetailDataSource)
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)

        switch actionType {
        case .LeaveGroup:
            Services.Group.Actions.leaveGroup(dataSource.selectedGroup.email, completionHandler: { (error) -> Void in
                hud.hide(true)
                if error == nil {
                    self.updateGroup()
                }
            })
            
        case .JoinGroup, .RequestGroup:
            Services.Group.Actions.joinGroup(dataSource.selectedGroup.email, completionHandler: { (request, error) -> Void in
                hud.hide(true)
                if let request = request where error == nil {
                    if request.status == .Approved {
                        self.showToast(AppStrings.GroupJoinSuccessConfirmation)
                    }
                    else {
                        self.showToast(AppStrings.GroupRequestSentConfirmation)
                    }
                    self.updateGroup()
                }
            })

        default:
            break
        }
    }
    
    private func updateGroup() {
        let dataSource = (self.dataSource as! GroupDetailDataSource)
        weak var weakSelf = self
        dataSource.updateGroup({ (error) -> Void in
            if error == nil {
                weakSelf?.loadData()
            }
            else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
    }
}
