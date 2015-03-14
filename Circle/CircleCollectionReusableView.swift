//
//  CircleCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

protocol CardHeaderViewDelegate {
    func cardHeaderTapped(card: Card!)
}

class CircleCollectionReusableView: UICollectionReusableView {

    class var classReuseIdentifier: String {
        return "CircleCollectionReusableView"
    }
    
    class var width: CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class var height: CGFloat {
        return 44.0
    }
    
    
    var currentCard: Card?
    var cardHeaderDelegate: CardHeaderViewDelegate?
    
    func setCard(card: Card) {
        currentCard = card
    }
}
