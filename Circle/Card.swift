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
        case Anniversaries = 1
        case Birthdays
        case Group
        case KeyValue
        case Locations
        case Notes
        case People
        case Placeholder
        case Tags
        
        struct CardTypeInfo {
            var imageName: String
            var classType: CircleCollectionViewCell.Type
            var className: String
        }
        
        static func infoByCardType(type: CardType) -> CardTypeInfo {
            switch type {
            
            case .Anniversaries:
                return CardTypeInfo(
                    imageName: "Jewel",
                    classType: ProfileCollectionViewCell.self,
                    className: "ProfileCollectionViewCell"
                )
                
            case .Birthdays:
                return CardTypeInfo(
                    imageName: "Cake",
                    classType: ProfileCollectionViewCell.self,
                    className: "ProfileCollectionViewCell"
                )
                
            case Group:
                return CardTypeInfo(
                    imageName: "People",
                    classType: ProfileImagesCollectionViewCell.self,
                    className: "ProfileImagesCollectionViewCell"
                )

            case KeyValue:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: KeyValueCollectionViewCell.self,
                    className: "KeyValueCollectionViewCell"
                )

            case Locations:
                return CardTypeInfo(
                    imageName: "MapPin",
                    classType: LocationCollectionViewCell.self,
                    className: "LocationCollectionViewCell"
                )

            case Notes:
                return CardTypeInfo(
                    imageName: "Notepad",
                    classType: NotesCollectionViewCell.self,
                    className: "NotesCollectionViewCell"
                )

            case People:
                return CardTypeInfo(
                    imageName: "People",
                    classType: ProfileCollectionViewCell.self,
                    className: "ProfileCollectionViewCell"
                )

            case Placeholder:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: CircleCollectionViewCell.self,
                    className: "CircleCollectionViewCell"
                )

            case Tags:
                return CardTypeInfo(
                    imageName: "Tag",
                    classType: TagsCollectionViewCell.self,
                    className: "TagsCollectionViewCell"
                )
            }
        }
    }
    
    required init(cardType: CardType, title withTitle: String) {
        type = cardType
        let infoByCardType = CardType.infoByCardType(type)
        imageSource = infoByCardType.imageName
        contentClass = infoByCardType.classType
        contentClassName = infoByCardType.className
        title = withTitle
        contentCount = 0
        content = []
    }
    
    func addContent(content withContent: [AnyObject]) {
        switch type {
        case .Group: content.append(withContent)
        default: content.extend(withContent)
        }
    }
    
}