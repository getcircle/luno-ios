//
//  QuickActionsCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 2/16/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class QuickActionsCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var addNoteButton: UIButton!
    @IBOutlet weak private(set) var callButton: UIButton!
    @IBOutlet weak private(set) var sendEmailButton: UIButton!
    @IBOutlet weak private(set) var sendTextButton: UIButton!
    
    override class var classReuseIdentifier: String {
        return "QuickActionsCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 78.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        configureButtons()
        selectedBackgroundView = nil
    }
    
    // MARK: - Configuration
    
    private func configureButtons() {
        for button in [addNoteButton, sendEmailButton, sendTextButton, callButton] {
            button.makeItCircular(true)
            button.setImage(
                button.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate),
                forState: .Normal
            )
            button.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            button.layer.borderColor = UIColor.appQuickActionsDarkTintColor().CGColor
        }
    }
    
    // MARK: - Data
    
    override func setData(data: AnyObject) {
        
    }
    
    // MARK: - IBActions
    
    @IBAction func addNoteButtonTapped(sender: AnyObject!) {
        triggerNotificationForQuickAction(.Note)
    }

    @IBAction func sendEmailButtonTapped(sender: AnyObject!) {
        triggerNotificationForQuickAction(.Email)
    }

    @IBAction func sendTextButtonTapped(sender: AnyObject!) {
        triggerNotificationForQuickAction(.Message)
    }

    @IBAction func callButtonTapped(sender: AnyObject!) {
        triggerNotificationForQuickAction(.Phone)
    }

    // MARK: - Helpers
    
    private func triggerNotificationForQuickAction(quickAction: QuickAction) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            QuickActionNotifications.onQuickActionStarted,
            object: nil, 
            userInfo: [
                QuickActionNotifications.QuickActionTypeUserInfoKey: quickAction.rawValue
            ]
        )
    }
}
