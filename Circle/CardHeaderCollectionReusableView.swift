//
//  CardHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 12/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class CardHeaderCollectionReusableView: CircleCollectionReusableView {
    
    override class var classReuseIdentifier: String {
        return "CardHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 44.0
    }
    
    @IBOutlet weak private(set) var cardContentCountLabel: UILabel!
    @IBOutlet weak private(set) var cardImageView: UIImageView!
    @IBOutlet weak private(set) var cardParentView: UIView!
    @IBOutlet weak private(set) var cardTitleLabel: UILabel!
    @IBOutlet weak private var cardTriggerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardImageView.tintColor = UIColor.blackColor()
        
        let selectionImage = UIImage.imageFromColor(
            UIColor.appControlHighlightedColor(),
            withRect: CGRectMake(0.0, 0.0, 1.0, 1.0)
        )

        cardTriggerButton.setBackgroundImage(selectionImage, forState: .Highlighted)
    }
    
    override func setCard(card: Card) {
        cardTitleLabel.text = card.title
        cardImageView.image = UIImage(named: card.imageSource)?.imageWithRenderingMode(.AlwaysTemplate)
        cardContentCountLabel.text = card.contentCountLabel()
        super.setCard(card)
    }
    
    @IBAction func cardHeaderTapped(sender: AnyObject!) {
        if let card = currentCard {
            cardHeaderDelegate?.cardHeaderTapped(sender, card: card)
        }
    }
}
