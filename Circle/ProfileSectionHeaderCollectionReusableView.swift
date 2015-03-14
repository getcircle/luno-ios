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
    @IBOutlet weak var addEditButton: UIButton!
    
    var showAddEditButton: Bool = false

    override class var classReuseIdentifier: String {
        return "ProfileSectionHeaderView"
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        cardTitleLabel.font = UIFont.appAttributeTitleLabelFont()
        cardTitleLabel.textColor = UIColor.appAttributeTitleLabelColor()
        addEditButton.tintColor = UIColor.appTintColor()
        addEditButton.setTitleColor(UIColor.appTintColor(), forState: .Normal)
        addEditButton.addTarget(self, action: "addEditButtonTapped:", forControlEvents: .TouchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showAddEditButton = false
    }
    
    override func setCard(card: Card) {
        cardTitleLabel.text = card.title.uppercaseStringWithLocale(NSLocale.currentLocale())
        addEditButton.alpha = showAddEditButton ? 1.0 : 0.0
        if showAddEditButton {
            let buttonTitle = card.content.count > 0 ? AppStrings.ProfileInfoEditButtonTitle : AppStrings.ProfileInfoAddButtonTitle
            addEditButton.setTitle(buttonTitle.uppercaseStringWithLocale(NSLocale.currentLocale()), forState: .Normal)
        }
        
        super.setCard(card)
    }
    
    @IBAction func addEditButtonTapped(sender: AnyObject!) {
        if let delegate = cardHeaderDelegate {
            if let card = currentCard {
                delegate.cardHeaderTapped(card)
            }
        }
    }
}
