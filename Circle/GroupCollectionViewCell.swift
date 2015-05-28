//
//  GroupCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 5/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

protocol GroupJoinRequestDelegate {
    func onJoinGroupButtonTapped(sender: UIView, group: Services.Group.Containers.GroupV1)
}

class GroupCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var groupNameLabel: UILabel!
    @IBOutlet weak private(set) var numberOfMembersLabel: UILabel!
    @IBOutlet weak private(set) var descriptionLabel: UILabel!
    @IBOutlet weak private(set) var joinButton: UIButton!
    
    var groupJoinRequestDelegate: GroupJoinRequestDelegate?
    
    private var group: Services.Group.Containers.GroupV1!
    
    override class var classReuseIdentifier: String {
        return "GroupCollectionViewCell";
    }

    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureViews()
        configureButtons()
    }
    
    // MARK: - Configuration
    
    private func configureViews() {
        groupNameLabel.font = UIFont.appPrimaryTextFont()
        groupNameLabel.textColor = UIColor.appPrimaryTextColor()
        descriptionLabel.font = UIFont.appSecondaryTextFont()
        descriptionLabel.textColor = UIColor.appSecondaryTextColor()
    }
    
    private func configureButtons() {
        joinButton.setTitleColor(UIColor.appTintColor(), forState: .Normal)
    }
    
    override func setData(data: AnyObject) {
        if let group = data as? Services.Group.Containers.GroupV1 {
            groupNameLabel.text = group.name
            descriptionLabel.text = group.groupDescription
            if group.membersCount == 1 {
                numberOfMembersLabel.text = AppStrings.GroupOneMemberCount
            }
            else {
                numberOfMembersLabel.text = NSString(format: AppStrings.GroupMembersCount, group.membersCount) as String
            }
            
            hideJoinRequestButton()
            if !group.isMember {
                if group.canJoin {
                    showJoinButton()
                }
                else if group.canRequest {
                    showRequestButton()
                }
            }

            self.group = group
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        for view in [groupNameLabel, numberOfMembersLabel, descriptionLabel] {
            view.layoutIfNeeded()
        }
        
        var height: CGFloat = 10.0
        height += groupNameLabel.intrinsicContentSize().height
        height += 5.0
        height += numberOfMembersLabel.intrinsicContentSize().height

        if group.groupDescription.trimWhitespace() != "" {
            height += 5.0
            height += descriptionLabel.intrinsicContentSize().height
        }
        
        if joinButton.alpha == 1.0 {
            height += 10.0 + joinButton.frameHeight
        }
        
        height += 10.0
        return CGSizeMake(self.dynamicType.width, height)
    }
    
    private func showJoinButton() {
        joinButton.alpha = 1.0
        joinButton.setTitle(AppStrings.GroupJoinGroupButtonTitle, forState: .Normal)
    }
    
    private func showRequestButton() {
        joinButton.alpha = 1.0
        joinButton.setTitle(AppStrings.GroupRequestToJoinGroupButtonTitle, forState: .Normal)
    }
    
    private func hideJoinRequestButton() {
        joinButton.alpha = 0.0
    }
    
    // MARK: - IBAction
    
    @IBAction func joinRequestedButtonTapped(sender: UIView!) {
        groupJoinRequestDelegate?.onJoinGroupButtonTapped(sender, group: group)
    }
    
}
