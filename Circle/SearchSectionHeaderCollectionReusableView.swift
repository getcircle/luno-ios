//
//  SearchSectionHeaderCollectionReusableView.swift
//  Luno
//
//  Created by Felix Mo on 2015-09-28.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit

class SearchSectionHeaderCollectionReusableView: CircleCollectionReusableView {

    @IBOutlet weak var cardTitleLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "SearchSectionHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 32.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardTitleLabel.textColor = UIColor.appSectionHeaderTextColor()
    }
    
    override func setCard(card: Card) {
        cardTitleLabel.attributedText = NSAttributedString.headerText(card.title.localizedUppercaseString())
        
        super.setCard(card)
    }
}
