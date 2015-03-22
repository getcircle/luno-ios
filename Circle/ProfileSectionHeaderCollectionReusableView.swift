//
//  ProfileSectionHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Michael Hahn on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class ProfileSectionHeaderCollectionReusableView: CircleCollectionReusableView {

    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var addEditButton: CircleButton!
    @IBOutlet weak var nextIconImage: UIImageView!
    @IBOutlet weak var cardContentCountLabel: UILabel!
    @IBOutlet weak var cardTriggerButton: UIButton!
    
    var showAddEditButton: Bool = false

    private var bottomBorder: UIView?
    
    var addBottomBorder: Bool? {
        didSet {
            if let addBorder = addBottomBorder {
                if bottomBorder == nil {
                    bottomBorder = cardTitleLabel.addBottomBorder(offset: 8.0)
                }
            }
        }
    }

    override class var classReuseIdentifier: String {
        return "ProfileSectionHeaderCollectionReusableView"
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        cardTitleLabel.font = UIFont.appAttributeTitleLabelFont()
        cardTitleLabel.textColor = UIColor.appAttributeTitleLabelColor()
        nextIconImage.alpha = 0.0
        cardContentCountLabel.alpha = 0.0
        cardTriggerButton.enabled = false
        addEditButton.alpha = 0.0
        configureAddEditButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showAddEditButton = false
    }
    
    // MARK: - Configuration
    
    private func configureAddEditButton() {
        addEditButton.addRoundCorners(radius: 3.0)
        addEditButton.tintColor = UIColor.appTintColor()
        addEditButton.setTitleColor(UIColor.appTintColor(), forState: .Normal)
        addEditButton.addTarget(self, action: "addEditButtonTapped:", forControlEvents: .TouchUpInside)
    }

    override func setCard(card: Card) {
        cardTitleLabel.text = card.title.uppercaseStringWithLocale(NSLocale.currentLocale())
        addEditButton.alpha = showAddEditButton ? 1.0 : 0.0
        nextIconImage.alpha = 0.0
        cardContentCountLabel.alpha = 0.0
        cardTriggerButton.enabled = false
        if showAddEditButton {
            let buttonTitle = card.content.count > 0 ? AppStrings.ProfileInfoEditButtonTitle : AppStrings.ProfileInfoAddButtonTitle
            addEditButton.setTitle(buttonTitle.uppercaseStringWithLocale(NSLocale.currentLocale()), forState: .Normal)
        }
    
        if !showAddEditButton && card.showContentCount {
            nextIconImage.alpha = 1.0
            cardContentCountLabel.alpha = 1.0
            cardContentCountLabel.text = card.contentCountLabel()
            cardTriggerButton.enabled = true
        }
        super.setCard(card)
    }
    
    @IBAction func addEditButtonTapped(sender: AnyObject!) {
        if let card = currentCard {
            cardHeaderDelegate?.cardHeaderTapped(sender, card: card)
        }
    }
    
    @IBAction func cardHeaderTapped(sender: AnyObject) {
        if let card = currentCard {
            cardHeaderDelegate?.cardHeaderTapped(sender, card: card)
        }
    }
}
