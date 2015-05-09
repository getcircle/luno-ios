//
//  GroupCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 5/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class GroupCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var groupNameLabel: UILabel!
    @IBOutlet weak private(set) var numberOfMembersLabel: UILabel!
    @IBOutlet weak private(set) var descriptionLabel: UILabel!
    @IBOutlet weak private(set) var joinButton: UIButton!
    
    override class var classReuseIdentifier: String {
        return "GroupCollectionViewCell";
    }
    
    override class var height: CGFloat {
        return 144.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Fixed
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureViews()
        selectedBackgroundView = nil
    }

    // MARK: - Configuration
    
    private func configureViews() {
        groupNameLabel.font = UIFont.appPrimaryTextFont()
        groupNameLabel.textColor = UIColor.appPrimaryTextColor()
        descriptionLabel.font = UIFont.appSecondaryTextFont()
        descriptionLabel.textColor = UIColor.appSecondaryTextColor()
    }
    
    override func setData(data: AnyObject) {
        if let group = data as? Services.Group.Containers.GroupV1 {
            groupNameLabel.text = group.name
            descriptionLabel.text = group.description_
            if group.membersCount == 1 {
                numberOfMembersLabel.text = AppStrings.GroupOneMemberCount
            }
            else {
                numberOfMembersLabel.text = NSString(format: AppStrings.GroupMembersCount, group.membersCount) as String
            }
            
            if group.canJoin {
                joinButton.alpha = 1.0
            }
            else {
                joinButton.alpha = 0.0
            }
        }
    }
}
