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
    @IBOutlet weak private(set) var footerNextImageView: UIImageView!
    @IBOutlet weak private var cardView: UIView!
    
    override class var classReuseIdentifier: String {
        return "CardFooterCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 48.0
    }
    
    var card: Card?
    var cardFooterDelegate: CardFooterViewDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        card = nil
        footerButton.enabled = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        footerButton.tintColor = UIColor.darkGrayColor()
        footerButton.setBackgroundImage(
            UIImage.imageFromColor(UIColor.appControlHighlightedColor(), withRect: footerButton.frame), 
            forState: .Highlighted
        )
        footerButton.setTitleColor(UIColor.appHighlightColor(), forState: .Normal)
        footerButton.titleLabel?.font = UIFont.regularFont(13.0)
        footerNextImageView.tintColor = UIColor.appHighlightColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        cardView.addRoundCorners(corners: .BottomLeft | .BottomRight, radius: 4.0)
    }
    
    func setButtonEnabled(enabled: Bool) {
        footerButton.enabled = enabled
    }
    
    func setButtonTitle(title: String) {
        footerButton.setTitle(title, forState: .Normal)
    }
    
    func setNextImageHidden(hidden: Bool) {
        footerNextImageView.hidden = hidden
    }
    
    // MARK: - IBActions
    
    @IBAction func footerButtonTapped(sender: AnyObject!) {
        cardFooterDelegate?.cardFooterTapped(card)
    }
}
