//
//  SettingsSectionHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Felix Mo on 2015-09-11.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class SettingsSectionHeaderCollectionReusableView: CircleCollectionReusableView {
    
    @IBOutlet private weak var cardTitleLabel: UILabel!

    override class var classReuseIdentifier: String {
        return "SettingsSectionHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 40.0
    }
    
    override func setCard(card: Card) {
        cardTitleLabel.attributedText = NSAttributedString.headerText(card.title.localizedUppercaseString())
        
        super.setCard(card)
    }
}
