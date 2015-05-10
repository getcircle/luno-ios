//
//  GroupHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 5/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class GroupHeaderCollectionReusableView: CircleCollectionReusableView {

    override class var classReuseIdentifier: String {
        return "GroupHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 200.0
    }
    
    @IBOutlet weak private(set) var groupNameLabel: UILabel!
    @IBOutlet weak private(set) var groupNameLabelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var groupSecondaryInfoLabel: UILabel!
    
    private(set) var groupNameLabelCenterYConstraintInitialValue: CGFloat!
    private(set) var groupNameLabelInitialFontSize: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupNameLabelCenterYConstraintInitialValue = groupNameLabelCenterYConstraint.constant
        groupNameLabelInitialFontSize = groupNameLabel.font.pointSize
    }
    
    func setData(group: Services.Group.Containers.GroupV1) {
        groupNameLabel.text = group.name
        if group.membersCount == 1 {
            groupSecondaryInfoLabel.text = AppStrings.GroupOneMemberCount
        }
        else {
            groupSecondaryInfoLabel.text = NSString(format: AppStrings.GroupMembersCount, group.membersCount) as String
        }

        backgroundColor = UIColor.appGroupHeaderBackgroundColor(group)
    }
}
