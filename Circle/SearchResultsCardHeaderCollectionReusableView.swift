//
//  SearchResultsCardHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class SearchResultsCardHeaderCollectionReusableView: CircleCollectionReusableView {

    @IBOutlet weak private(set) var cardTitleLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "SearchResultsCardHeaderView"
    }
    
    override class var height: CGFloat {
        return 30.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardTitleLabel.addBottomBorder()
    }
    
    func setCard(card: Card) {
        cardTitleLabel.text = card.title.uppercaseStringWithLocale(NSLocale.currentLocale())
    }
}
