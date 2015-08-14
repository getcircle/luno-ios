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
    @IBOutlet weak private(set) var footerButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var footerButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var footerImageView: UIImageView!
    @IBOutlet weak private(set) var footerNextImageView: UIImageView!
 
    override class var classReuseIdentifier: String {
        return "CardFooterCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 70.0
    }
    
    var card: Card?
    var cardFooterDelegate: CardFooterViewDelegate?
    var insetEdges: Bool = true {
        didSet {
            updateViewForInsetEdges()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        card = nil
        footerImageView.hidden = true
        footerButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        footerButton.tintColor = UIColor.darkGrayColor()
        footerButton.addBottomBorder(offset: 1.0)
        footerButton.setBackgroundImage(
            UIImage.imageFromColor(UIColor.appControlHighlightedColor(), withRect: footerButton.frame), 
            forState: .Highlighted
        )
        footerImageView.hidden = true
        footerButton.setTitleColor(UIColor.appPrimaryTextColor(), forState: .Normal)
        footerButton.titleLabel?.font = UIFont.appPrimaryTextFont()
    }
    
    func setButtonTitle(title: String) {
        footerButton.setTitle(title, forState: .Normal)
    }
    
    func setImage(image: UIImage?) {
        footerImageView.image = image
        footerImageView.hidden = false
        footerButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 15.0 + footerImageView.frameWidth + 10.0, 0.0, 0.0)
    }
    
    func setNextImageHidden(hidden: Bool) {
        footerNextImageView.hidden = hidden
    }
    
    private func updateViewForInsetEdges() {
        if insetEdges {
            footerButtonLeadingConstraint.constant = 10.0
            footerButtonTrailingConstraint.constant = 10.0
        }
        else {
            footerButtonLeadingConstraint.constant = 0.0
            footerButtonTrailingConstraint.constant = 0.0
        }
        
        footerButton.setNeedsUpdateConstraints()
        footerButton.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    
    @IBAction func footerButtonTapped(sender: AnyObject!) {
        cardFooterDelegate?.cardFooterTapped(card)
    }
}
