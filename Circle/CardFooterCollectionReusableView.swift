//
//  CardFooterCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/24/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

protocol CardFooterViewDelegate {
    func cardFooterTapped(card: Card!)
}

class CardFooterCollectionReusableView: CircleCollectionReusableView {

    @IBOutlet weak private(set) var footerButton: UIButton!
 
    override class var classReuseIdentifier: String {
        return "CardFooterCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 40.0
    }
    
    var card: Card!
    var cardFooterDelegate: CardFooterViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func configureFooterButton() {
        setButtonTitle()
    }
    
    @IBAction func footerButtonTapped(sender: AnyObject!) {
        cardFooterDelegate?.cardFooterTapped(card)
        setButtonTitle()
    }
    
    private func setButtonTitle() {
        if card.isContentAllContent() {
            footerButton.setTitle(
                NSLocalizedString("Show less", comment: "Button to show more content"),
                forState: .Normal
            )
        }
        else {
            footerButton.setTitle(
                NSLocalizedString("Show more", comment: "Button to hide some content"),
                forState: .Normal
            )
        }
    }
}
