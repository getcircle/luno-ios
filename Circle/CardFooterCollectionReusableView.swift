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
    
    var card: Card? {
        didSet {
            setButtonTitle()
        }
    }
    var cardFooterDelegate: CardFooterViewDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        card = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        footerButton.tintColor = UIColor.darkGrayColor()
        footerButton.addBottomBorder(offset: 1.0)
    }
    
    @IBAction func footerButtonTapped(sender: AnyObject!) {
        cardFooterDelegate?.cardFooterTapped(card)
        setButtonTitle()
    }
    
    private func setButtonTitle() {
        UIView.setAnimationsEnabled(false)
        if card != nil && (card?.isContentAllContent() ?? false) {
            footerButton.setImage(UIImage(named: "Up")?.templateImage(), forState: .Normal)
        }
        else {
            footerButton.setImage(UIImage(named: "Down")?.templateImage(), forState: .Normal)
        }
        UIView.setAnimationsEnabled(true)
    }
}
