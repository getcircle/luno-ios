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
    @IBOutlet weak var cardSubtitleLabel: UILabel!
    @IBOutlet weak var updateButton: CircleButton!
    @IBOutlet private(set) weak var cardView: UIView!
    
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
        cardSubtitleLabel.textColor = UIColor.appSecondaryTextColor()
        configureUpdateButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateButton.hidden = true
        addBottomBorder = false
        cardSubtitleLabel.hidden = true
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        cardView.addRoundCorners(corners: .TopLeft | .TopRight, radius: 4.0)
        configureBottomBorder()
    }
    
    // MARK: - Configuration
    
    private func configureUpdateButton() {
        let attributedTitle = NSMutableAttributedString(attributedString: NSAttributedString.headerText(AppStrings.ProfileInfoUpdateButtonTitle.localizedUppercaseString()))
        attributedTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.appHighlightColor(), range: NSMakeRange(0, count(attributedTitle.string)))
        
        updateButton.setAttributedTitle(attributedTitle, forState: .Normal)
        updateButton.sizeToFit()
    }
    
    private func configureBottomBorder() {
        if addBottomBorder && bottomBorder == nil {
            bottomBorder = cardView.addBottomBorder()
        }
        bottomBorder?.hidden = !addBottomBorder
    }
    
    override func setCard(card: Card) {
        updateButton.hidden = !card.allowEditingContent
        cardTitleLabel.attributedText = NSAttributedString.headerText(card.title.localizedUppercaseString())
        
        super.setCard(card)
    }
    
    @IBAction func updateButtonTapped(sender: AnyObject!) {
        if let card = currentCard {
            cardHeaderDelegate?.cardHeaderTapped(sender, card: card)
        }
    }
}
