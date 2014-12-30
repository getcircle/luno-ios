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
    private(set) var contentClass: CircleCollectionViewCell.Type
    private(set) var contentClassName: String
    private(set) var imageSource: String
    private(set) var title: String
    private(set) var type: CardType
    
    enum CardType: Int {
        case People = 1
        case Tags
        case Locations
        
        static func imageSourceByCardType(type: CardType) -> String {
            switch type {
            case .People:
                return "People"
            
            case .Tags:
                return "Tag"

            case .Locations:
                return "MapPin"
            }
        }
        
        static func classByCardType(type: CardType) -> (CircleCollectionViewCell.Type, className: String) {
            switch type {
            case .People:
                return (ProfileImagesCollectionViewCell.self, "ProfileImagesCollectionViewCell")
            
            case .Tags:
                return (TagsCollectionViewCell.self, "TagsCollectionViewCell")

            case .Locations:
                return (LocationCollectionViewCell.self, "LocationCollectionViewCell")
            }
        }
    }
    
    required init(cardType: CardType, title withTitle: String) {
        type = cardType
        imageSource = CardType.imageSourceByCardType(type)
        (contentClass, contentClassName) = CardType.classByCardType(type)
        title = withTitle
        contentCount = 0
        content = []
    }
}