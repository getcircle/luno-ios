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

    @IBOutlet weak private(set) var firstButton: UIButton!
    @IBOutlet weak private(set) var firstButtonLabel: UILabel!
    @IBOutlet weak private(set) var firstButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var fourthButton: UIButton!
    @IBOutlet weak private(set) var fourthButtonLabel: UILabel!
    @IBOutlet weak private(set) var secondButton: UIButton!
    @IBOutlet weak private(set) var secondButtonLabel: UILabel!
    @IBOutlet weak private(set) var thirdButton: UIButton!
    @IBOutlet weak private(set) var thirdButtonLabel: UILabel!
    
    private var actionButtons = [UIButton]()
    private var actionButtonLabels = [UILabel]()
    private var areLabelsHidden = false
    private let defaultQuickActions: [QuickAction] = [.Phone, .Message, .Email, .Note]
    private var firstButtonTopConstraintInitialValue: CGFloat = 0.0
    private var profile: ProfileService.Containers.Profile?
    
    /**
        Quick actions that need to be shown. Only the first four are added to the UI.
    
    */
    var quickActions: [QuickAction] = [QuickAction]() {
        didSet {
            configureButtons()
        }
    }
    
    
    override class var classReuseIdentifier: String {
        return "QuickActionsCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 70.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        actionButtons = [firstButton, secondButton, thirdButton, fourthButton]
        actionButtonLabels = [firstButtonLabel, secondButtonLabel, thirdButtonLabel, fourthButtonLabel]
        firstButtonTopConstraintInitialValue = firstButtonTopConstraint.constant
        configureButtons()
        selectedBackgroundView = nil
    }
    
    // MARK: - Configuration
    
    private func configureButtons() {
        let quickActionsToAdd = quickActions.count > 0 ? quickActions : defaultQuickActions
        for (index, button) in enumerate(actionButtons) {
            if index < quickActionsToAdd.count {
                let metaInfo = QuickAction.metaInfoForQuickAction(quickActionsToAdd[index])
                button.setImage(UIImage(named: metaInfo.imageSource), forState: .Normal)
                actionButtonLabels[index].text = metaInfo.actionLabel.localizedUppercaseString()
                button.convertToTemplateImageForState(.Normal)
                button.alpha = 1.0
                button.tag = index
                button.tintColor = UIColor.appQuickActionsDarkTintColor()
                button.addTarget(self, action: "quickActionTapped:", forControlEvents: .TouchUpInside)
            }
            else {
                button.alpha = 0.0
            }
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
    
    // MARK: Hide, Show Labels
    
    func hideLabels() {
        for buttonLabel in actionButtonLabels {
            buttonLabel.alpha = 0.0
        }
        
        
        areLabelsHidden = true
        setTopConstaintToValue((frameHeight - thirdButton.frameHeight) / 2)
    }
    
    func showLabels() {
        for buttonLabel in actionButtonLabels {
            buttonLabel.alpha = 1.0
        }
        
        areLabelsHidden = false
        setTopConstaintToValue(firstButtonTopConstraintInitialValue)
    }
    
    private func setTopConstaintToValue(value: CGFloat) {
        firstButtonTopConstraint.constant = value
        for button in actionButtons {
            button.setNeedsUpdateConstraints()
            button.layoutIfNeeded()
        }
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(CircleCollectionViewCell.width, areLabelsHidden == true ? 70.0 : 90.0)
    }
    
    // MARK: - IBActions
    
    @IBAction func quickActionTapped(sender: UIButton!) {
        if let quickAction = quickActionAtIndex(sender.tag) {
            triggerNotificationForQuickAction(quickAction)
        }
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
    
    private func quickActionAtIndex(index: Int) -> QuickAction? {
        let possibleQuickActions = quickActions.count > 0 ? quickActions : defaultQuickActions
        if index < possibleQuickActions.count {
            return possibleQuickActions[index]
        }
        
        return nil
    }
}
