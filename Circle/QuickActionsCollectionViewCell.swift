//
//  QuickActionsCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 2/16/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class QuickActionsCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var addNoteButton: UIButton!
    @IBOutlet weak private(set) var addNoteButtonLabel: UILabel!
    @IBOutlet weak private(set) var callButton: UIButton!
    @IBOutlet weak private(set) var callButtonLabel: UILabel!
    @IBOutlet weak private(set) var firstButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var sendEmailButton: UIButton!
    @IBOutlet weak private(set) var sendEmailButtonLabel: UILabel!
    @IBOutlet weak private(set) var sendTextButton: UIButton!
    @IBOutlet weak private(set) var sendTextButtonLabel: UILabel!
    
    private var actionButtons = [UIButton]()
    private var actionButtonLabels = [UILabel]()
    private var firstButtonTopConstraintInitialValue: CGFloat = 0.0
    private var profile: ProfileService.Containers.Profile?
    
    override class var classReuseIdentifier: String {
        return "QuickActionsCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 90.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        actionButtons = [addNoteButton, callButton, sendEmailButton, sendTextButton]
        actionButtonLabels = [addNoteButtonLabel, callButtonLabel, sendEmailButtonLabel, sendTextButtonLabel]
        firstButtonTopConstraintInitialValue = firstButtonTopConstraint.constant
        configureButtons()
        selectedBackgroundView = nil
    }
    
    // MARK: - Configuration
    
    private func configureButtons() {
        for button in actionButtons {
            button.makeItCircular(true, borderColor: UIColor.appQuickActionsDarkTintColor())
            button.setImage(
                button.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate),
                forState: .Normal
            )
            button.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        }
    }
    
    // MARK: - Data
    
    override func setData(data: AnyObject) {
        if let dataDictionary = data as? [String: ProfileService.Containers.Profile] {
            if let userProfile = dataDictionary["profile"] as ProfileService.Containers.Profile? {
                profile = userProfile
            }
        }
    }
    
    // MARK: Hide, Show Borders
    
    func hideBorders() {
        for button in actionButtons {
            button.layer.borderColor = backgroundColor?.CGColor
        }
    }
    
    func addBorders() {
        for button in actionButtons {
            button.layer.borderColor = UIColor.appQuickActionsDarkTintColor().CGColor
        }
    }

    // MARK: Hide, Show Labels
    
    func hideLabels() {
        for buttonLabel in actionButtonLabels {
            buttonLabel.alpha = 0.0
        }
        
        setTopConstaintToValue((frameHeight - addNoteButton.frameHeight) / 2)
    }
    
    func showLabels() {
        for buttonLabel in actionButtonLabels {
            buttonLabel.alpha = 1.0
        }
        
        setTopConstaintToValue(firstButtonTopConstraintInitialValue)
    }
    
    private func setTopConstaintToValue(value: CGFloat) {
        firstButtonTopConstraint.constant = value
        for button in actionButtons {
            button.setNeedsUpdateConstraints()
            button.layoutIfNeeded()
        }
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
        var userInfo = [
            QuickActionNotifications.QuickActionTypeUserInfoKey: quickAction.rawValue
        ]

        NSNotificationCenter.defaultCenter().postNotificationName(
            QuickActionNotifications.onQuickActionStarted,
            object: nil, 
            userInfo: userInfo
        )
    }
}
