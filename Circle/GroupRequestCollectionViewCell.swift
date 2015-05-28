//
//  GroupRequestCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 5/10/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

protocol GroupRequestDelegate {
    func onGroupRequestActionTaken(
        sender: UIView, 
        request: Services.Group.Containers.MembershipRequestV1, 
        status: Services.Group.Actions.RespondToMembershipRequest.RequestV1.ResponseActionV1
    )
}

class GroupRequestCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var notificationMessageLabel: UILabel!
    @IBOutlet weak private(set) var approveButton: UIButton!
    @IBOutlet weak private(set) var denyButton: UIButton!
    
    var groupRequestDelegate: GroupRequestDelegate?
    
    private var membershipRequest: Services.Group.Containers.MembershipRequestV1!

    override class var classReuseIdentifier: String {
        return "GroupRequestCollectionViewCell";
    }
    
    override class var height: CGFloat {
        return 100.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        selectedBackgroundView = nil
        configureViews()
        configureButtons()
    }
    
    // MARK: - Configuration

    private func configureViews() {
    }
    
    private func configureButtons() {
        approveButton.backgroundColor = UIColor.appTintColor()
        approveButton.setTitleColor(UIColor.appDefaultLightTextColor(), forState: .Normal)
        
        denyButton.backgroundColor = UIColor.appSecondaryCTABackgroundColor()
        denyButton.setTitleColor(UIColor.appDefaultLightTextColor(), forState: .Normal)
    }
    
    override func setData(data: AnyObject) {
        if let membershipRequest = data as? Services.Group.Containers.MembershipRequestV1 {
            
            let profileName = membershipRequest.requesterProfileId
            let groupName = membershipRequest.groupKey
            
            let message = NSString(format:AppStrings.GroupRequestMessage, profileName, groupName)
            let messageAttributed = NSMutableAttributedString(string: message as String)
            messageAttributed.addAttribute(
                NSFontAttributeName,
                value: UIFont(name: "Avenir-Heavy", size: notificationMessageLabel.font.pointSize)!,
                range: message.rangeOfString(profileName)
            )

            messageAttributed.addAttribute(
                NSFontAttributeName,
                value: UIFont(name: "Avenir-Heavy", size: notificationMessageLabel.font.pointSize)!,
                range: message.rangeOfString(groupName)
            )
            
            notificationMessageLabel.attributedText = messageAttributed
            self.membershipRequest = membershipRequest
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        // 30.0 is the hardcoded number based on the gap size between label and buttons
        notificationMessageLabel.layoutIfNeeded()
        let intrinsicSize = notificationMessageLabel.intrinsicContentSize()
        let dynamicHeight = intrinsicSize.height + 30.0 + approveButton.frameHeight
        return CGSizeMake(self.dynamicType.width, dynamicHeight)
    }
    
    // MARK: - IBActions
    
    @IBAction func approveRequestButtonTapped(sender: UIView) {
        groupRequestDelegate?.onGroupRequestActionTaken(sender, request: membershipRequest, status: .Approve)
    }

    @IBAction func denyRequestButtonTapped(sender: UIView) {
        groupRequestDelegate?.onGroupRequestActionTaken(sender, request: membershipRequest, status: .Deny)
    }
}
