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
    
    private var bottomBorder: UIView?
    
    var addBottomBorder: Bool? {
        didSet {
            if let addBorder = addBottomBorder {
                if bottomBorder == nil {
                    bottomBorder = cardTitleLabel.addBottomBorder(offset: 8.0)
                }
            }
        }
    }
    
    override class var classReuseIdentifier: String {
        return "SearchResultsCardHeaderView"
    }
    
    override class var height: CGFloat {
        return 36.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func setCard(card: Card) {
        cardTitleLabel.text = card.title.uppercaseStringWithLocale(NSLocale.currentLocale())
    }
}
