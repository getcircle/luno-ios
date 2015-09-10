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
    
    var showAddEditButton: Bool = false
    var addBottomBorder = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var bottomBorder: UIView?

    override class var classReuseIdentifier: String {
        return "ProfileSectionHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 32.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        cardTitleLabel.textColor = UIColor.appSectionHeaderTextColor()
        addEditButton.alpha = 0.0
        configureAddEditButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showAddEditButton = false
        addBottomBorder = false
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        configureBottomBorder()
    }
    
    // MARK: - Configuration
    
    private func configureAddEditButton() {
        addEditButton.addRoundCorners(radius: 3.0)
        addEditButton.tintColor = UIColor.appTintColor()
        addEditButton.setTitleColor(UIColor.appTintColor(), forState: .Normal)
    }
    
    private func configureBottomBorder() {
        if addBottomBorder && bottomBorder == nil {
            bottomBorder = addBottomBorder()
        }
        bottomBorder?.hidden = !addBottomBorder
    }
    
    override func setCard(card: Card) {
        addEditButton.alpha = showAddEditButton ? 1.0 : 0.0
        if showAddEditButton {
            let buttonTitle = card.content.count > 0 ? AppStrings.ProfileInfoEditButtonTitle : AppStrings.ProfileInfoAddButtonTitle
            addEditButton.setTitle(buttonTitle.localizedUppercaseString(), forState: .Normal)
        }
        cardTitleLabel.attributedText = NSAttributedString.headerText(card.title.localizedUppercaseString())
        
        super.setCard(card)
    }
    
    @IBAction func addEditButtonTapped(sender: AnyObject!) {
        if let card = currentCard {
            cardHeaderDelegate?.cardHeaderTapped(sender, card: card)
        }
    }
}
