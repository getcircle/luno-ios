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
        case KeyValue
        case Locations
        case Notes
        case People
        case Tags
        
        static func imageSourceByCardType(type: CardType) -> String {
            switch type {
            case .Birthdays:
                return "Cake"
                
            case .KeyValue:
                return "Info"

            case .Locations:
                return "MapPin"

            case .Notes:
                return "Notepad"

            case .People:
                return "People"
            
            case .Tags:
                return "Tag"
            }
        }
        
        static func classByCardType(type: CardType) -> (CircleCollectionViewCell.Type, className: String) {
            switch type {
            case .Birthdays:
                return (PersonCollectionViewCell.self, "PersonCollectionViewCell")
            
            case .KeyValue:
                return (KeyValueCollectionViewCell.self, "KeyValueCollectionViewCell")

            case .Locations:
                return (LocationCollectionViewCell.self, "LocationCollectionViewCell")

            case .Notes:
                return (NotesCollectionViewCell.self, "NotesCollectionViewCell")

            case .People:
                return (ProfileImagesCollectionViewCell.self, "ProfileImagesCollectionViewCell")
            
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