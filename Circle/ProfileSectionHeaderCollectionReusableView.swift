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
    @IBOutlet weak var cardImageView: UIImageView!
    
    override class var classReuseIdentifier: String {
        return "ProfileSectionHeaderView"
    }
    
    override class var height: CGFloat {
        return 36.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardTitleLabel.font = UIFont.appAttributeTitleLabelFont()
    }
    
    func setCard(card: Card) {
        cardTitleLabel.text = card.title.uppercaseStringWithLocale(NSLocale.currentLocale())
        cardImageView.image = UIImage(named: card.imageSource)
    }
    
}
