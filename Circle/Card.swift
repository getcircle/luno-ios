//
//  Card.swift
//  Circle
//
//  Created by Ravi Rani on 12/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation

class Card {
    var content: [AnyObject]
    var contentCount: Int
    private(set) var imageSource: String
    private(set) var title: String
    private(set) var type: CardType
    
    enum CardType: Int {
        case People = 1
        
        static func imageSource(type: CardType) -> String {
            switch type {
            case .People:
                return "People"
            }
        }
    }
    
    required init(cardType: CardType, title withTitle: String) {
        type = cardType
        imageSource = CardType.imageSource(type)
        title = withTitle
        contentCount = 0
        content = []
    }
}