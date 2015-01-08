//
//  Card.swift
//  Circle
//
//  Created by Ravi Rani on 12/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation

func ==(lhs: Card, rhs: Card) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

class Card: Equatable {
    var content: [AnyObject]
    var contentCount: Int
    private(set) var contentClass: CircleCollectionViewCell.Type
    private(set) var contentClassName: String
    private(set) var imageSource: String
    var sectionInset = UIEdgeInsetsMake(1.0, 10.0, 25.0, 10.0)
    private(set) var title: String
    private(set) var type: CardType
    
    enum CardType: Int {
        case Birthdays = 1
        case Group
        case KeyValue
        case Locations
        case Map
        case Notes
        case People
        case Placeholder
        case Tags
        
        static func imageSourceByCardType(type: CardType) -> String {
            switch type {
            case .Birthdays:
                return "Cake"
            
            case .KeyValue:
                return "Info"

            case .Locations, .Map:
                return "MapPin"

            case .Notes:
                return "Notepad"

            case .Group, .People, .Placeholder:
                return "People"
            
            case .Tags:
                return "Tag"
            }
        }
        
        static func classByCardType(type: CardType) -> (CircleCollectionViewCell.Type, className: String) {
            switch type {
            case .Birthdays, .People:
                return (ProfileCollectionViewCell.self, "ProfileCollectionViewCell")
            
            case .Group:
                return (ProfileImagesCollectionViewCell.self, "ProfileImagesCollectionViewCell")

            case .KeyValue:
                return (KeyValueCollectionViewCell.self, "KeyValueCollectionViewCell")

            case .Locations:
                return (LocationCollectionViewCell.self, "LocationCollectionViewCell")

            case .Map:
                return (MapCollectionViewCell.self, "MapCollectionViewCell")

            case .Notes:
                return (NotesCollectionViewCell.self, "NotesCollectionViewCell")

            case .Placeholder:
                return (CircleCollectionViewCell.self, "CircleCollectionViewCell")

            case .Tags:
                return (TagsCollectionViewCell.self, "TagsCollectionViewCell")
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