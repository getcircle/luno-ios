//
//  TeamDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/17/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import ProtobufRegistry

class TeamDetailViewController:
    DetailViewController,
    EditTeamViewControllerDelegate,
    CardHeaderViewDelegate,
    CardFooterViewDelegate,
    TextValueCollectionViewDelegate {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()

        dataSource = TeamDetailDataSource()
        delegate = CardCollectionViewDelegate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Tracker.sharedInstance.trackPageView(
            pageType: .TeamDetail, 
            pageId: (dataSource as! TeamDetailDataSource).team.id
        )
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        dataSource.cardHeaderDelegate = self
        dataSource.cardFooterDelegate = self
        (dataSource as? TeamDetailDataSource)?.textDataDelegate = self
        
        // Delegate
        collectionView.delegate = delegate
        
        (layout as! StickyHeaderCollectionViewLayout).headerHeight = ProfileHeaderCollectionReusableView.heightWithoutSecondaryInfo
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let tappedCard = dataSource.cardAtSection(indexPath.section) {
            switch tappedCard.type {
            case .Profiles:
                if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                    showProfileDetail(profile)
                }
                else if let team = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.TeamV1 {
                    showTeamDetail(team)
                }

            default:
                break
            }
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }

    // MARK: - EditTeamViewControllerDelegate
    
    func onTeamDetailsUpdated(team: Services.Organization.Containers.TeamV1) {
        (dataSource as! TeamDetailDataSource).team = team
        loadData()
    }
    
    // MARK: - Notifications
    
    override func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, 
            selector: "loadData",
            name: TeamServiceNotifications.onTeamUpdatedNotification, 
            object: nil
        )
    }
    
    override func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: TeamServiceNotifications.onTeamUpdatedNotification,
            object: nil
        )
    }
    
    // Image Upload
    
    internal override func handleImageUpload(completion: () -> Void) {
        let dataSource = (self.dataSource as! TeamDetailDataSource)
        if let newImage = imageToUpload {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            Services.Media.Actions.uploadImage(
                newImage,
                forMediaType: .Team,
                withKey: dataSource.team.id
                ) { (mediaURL, error) -> Void in
                    if let mediaURL = mediaURL {
                        do {
                            let teamBuilder = try dataSource.team.toBuilder()
                            teamBuilder.imageUrl = mediaURL
                            Services.Organization.Actions.updateTeam(try teamBuilder.build()) { (team, error) -> Void in
                                if let team = team {
                                    dataSource.team = team
                                    hud.hide(true)
                                    completion()
                                }
                            }
                        }
                        catch {
                            print("Error: \(error)")
                            
                            hud.hide(true)
                        }
                    }
            }
        }
    }
    
    internal override func reloadHeader() {
        if let dataSource = dataSource as? TeamDetailDataSource {
            if let headerView = dataSource.profileHeaderView {
                headerView.setTeam(dataSource.team)
            }
        }
    }
    
    // MARK: - CardHeaderViewDelegate
    
    func cardHeaderTapped(sender: AnyObject!, card: Card!) {
        switch card.type {
        case .TextValue:
            if card.content.count > 0 {
                if let data = card.content.first as? TextData {
                    switch data.type {
                    case .TeamStatus:
                        openEditTeamStatus(true)

                    default:
                        break
                    }
                }
            }
            break
            
        default:
            break
        }
    }
    
    private func openEditTeamStatus(isNew: Bool) {
        let editStatusViewController = EditTeamStatusViewController(
            addCharacterLimit: true,
            isNew: isNew,
            withDelegate: self
        )
        editStatusViewController.addPostButton = true
        editStatusViewController.team = (dataSource as! TeamDetailDataSource).team
        let editStatusViewNavController = UINavigationController(
            rootViewController: editStatusViewController
        )
        navigationController?.presentViewController(
            editStatusViewNavController,
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - CardFooterDelegate
    
    func cardFooterTapped(card: Card!) {
        let teamDetailDataSource = dataSource as! TeamDetailDataSource
        switch card.type {
        case .Profiles:
            do {
                switch card.subType {
                case .Members:
                    let viewController = ProfilesViewController()
                    viewController.dataSource.setInitialData(
                        content: card.allContent,
                        ofType: nil,
                        nextRequest: teamDetailDataSource.profilesNextRequest
                    )
                    viewController.title = "People in " + teamDetailDataSource.team.getName()
                    viewController.pageType = .TeamMembers
                    try (viewController.dataSource as! ProfilesDataSource).configureForTeam(teamDetailDataSource.team.id, setupOnlySearch: true)
                    (viewController.dataSource as! ProfilesDataSource).searchLocation = .Home
                    navigationController?.pushViewController(viewController, animated: true)
                    
                case .Teams:
                    let viewController = TeamsOverviewViewController()
                    viewController.dataSource.setInitialData(
                        content: card.allContent,
                        ofType: nil,
                        nextRequest: nil
                    )
                    viewController.title = "Teams in " + teamDetailDataSource.team.getName()
                    viewController.pageType = .TeamSubTeams
                    (viewController.dataSource as! TeamsOverviewDataSource).searchLocation = .Modal
                    try (viewController.dataSource as! TeamsOverviewDataSource).configureForTeam(teamDetailDataSource.team.id, setupOnlySearch: true)
                    navigationController?.pushViewController(viewController, animated: true)
                    
                default:
                    break
                }
            }
            catch {
                print("Error: \(error)")
            }
            
        default:
            break
        
        }
    }
    
    // MARK: - TextInputViewControllerDelegate
    
    override func onTextInputValueUpdated(updatedObject: AnyObject?) {
        if let team = updatedObject as? Services.Organization.Containers.TeamV1 {
            (dataSource as! TeamDetailDataSource).team = team
        }

        super.onTextInputValueUpdated(updatedObject)
    }
    
    // MARK: - Actions
    
    override func editButtonTapped(sender: AnyObject) {
        let editTeamViewController = EditTeamViewController(nibName: "EditTeamViewController", bundle: nil)
        let editTeamNavController = UINavigationController(rootViewController: editTeamViewController)
        editTeamViewController.team = (dataSource as! TeamDetailDataSource).team
        editTeamViewController.editTeamViewControllerDelegate = self
        navigationController?.presentViewController(editTeamNavController, animated: true, completion: nil)
    }
    
    // MARK: - TextValueCollectionViewDelegate
    
    func placeholderButtonTapped(type: TextData.TextDataType) {
        if let loggedInUserProfile = AuthenticationViewController.getLoggedInUserProfile(),
            loggedInUserOrg = AuthenticationViewController.getLoggedInUserOrganization(),
            dataSource = dataSource as? TeamDetailDataSource
        {
            let team = dataSource.team
            var contactLocation: TrackerProperty.ContactLocation!
            var source = ""
            var fields = [String]()
            let dataDictionary = ["name": team.name, "description": team.description_?.value ?? "", "status": team.status?.value ?? ""];
            
            for key in ["name", "description", "status"] {
                if dataDictionary[key]?.trimWhitespace() == "" {
                    fields.append(key)
                }
            }
            
            // if there are at least two elements add an `and`
            if fields.count > 1 {
                fields[fields.count - 1] = "and " + fields[fields.count - 1]
            }
            
            if type == .TeamStatus {
                contactLocation = .TeamDetailStatus
                source = "team_status_askme"
            }
            else if type == .TeamDescription {
                contactLocation = .TeamDetailDescription
                source = "team_description_askme"
            }
            
            Tracker.sharedInstance.trackContactTap(
                .Email,
                contactProfile: dataSource.managerProfile,
                contactLocation: contactLocation
            )
            
            presentMailViewController(
                [dataSource.managerProfile.email],
                subject: "Update your team's info in Luno",
                messageBody: NSString(
                    format: "Hey %@,<br/><br/>Can you update update your team's %@ in Luno?<br/><br/>%@<br/><br/>Thanks!<br/>%@",
                    dataSource.managerProfile.firstName,
                    fields.joinWithSeparator(", "),
                    loggedInUserOrg.getURL("team/" + team.id + "?ls=" + source),
                    loggedInUserProfile.firstName
                ) as String,
                completionHandler: nil
            )
        }
    }
    
    func editTextButtonTapped(type: TextData.TextDataType) {
        openEditTeamStatus(false)
    }
}
