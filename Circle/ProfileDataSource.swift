//
//  ProfileDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class ProfileDataSource: CardDataSource {

    var person: Person!
    enum CellType: String {
        case Email = "email"
        case CellPhone = "cell"
        case Twitter = "twitter"
        case Facebook = "facebook"
        case LinkedIn = "linkedin"
        case Github = "github"
        case Manager = "manager"
        case Other = "other"
        
        static let allValues = [Email, CellPhone, Twitter, Facebook, LinkedIn, Github, Manager]
        static func typeByKey(key: String) -> CellType {
            for value in self.allValues {
                if value.rawValue == key {
                    return value
                }
            }
            
            return .Other
        }
    }
    
    private (set) var profileHeaderView: ProfileHeaderCollectionReusableView?
    private var attributes: [String] = []

    let baseInfoKeySet = [
        "email",
        "cell",
        "location",
        "country"
    ]

    let socialInfoKeySet = [
        "twitter",
        "facebook",
        "pinterest",
        "linkedin",
        "github"
    ]
    
    let managerInfoKeySet = [
        "manager",
        "department"
    ]

    let keyToTitle = [
        "email": "Email",
        "cell": "Cell Phone",
        "location": "City",
        "country": "Country",
        "manager": "Manager",
        "department": "Department",
        "twitter": "Twitter",
        "facebook": "Facebook",
        "pinterest": "Pinterest",
        "linkedin": "LinkedIn",
        "github": "Github"
    ]
    
    let keyToImageDictionary: [String: [String: AnyObject]] = [
        "twitter": [
            "image": "Twitter",
            "tintColor": UIColor.twitterColor(),
        ],
        "facebook": [
            "image": "Facebook",
            "tintColor": UIColor.facebookColor(),
        ],
        "pinterest": [
            "image": "Pinterest",
            "tintColor": UIColor.pinterestColor(),
        ],
        "linkedin": [
            "image": "LinkedIn",
            "tintColor": UIColor.linkedinColor(),
        ],
        "github": [
            "image": "Github",
            "tintColor": UIColor.githubColor(),
        ],
        "email": [
            "image": "EmailCircle",
            "tintColor": UIColor.emailTintColor(),
        ],
        "cell": [
            "image": "Telephone",
            "tintColor": UIColor.phoneTintColor(),
        ],
    ]

    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier
        )
        
        super.registerCardHeader(collectionView)
    }

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        var defaultSectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
        
        for dataSet in [baseInfoKeySet, socialInfoKeySet, managerInfoKeySet] {
            var keyValueCard = Card(cardType: .KeyValue, title: "Info")
            for key in dataSet {
                if let value: AnyObject = self.person.valueForKey(key) {
                    var dataDict: [String: AnyObject!] = [
                        "key": key,
                        "name": keyToTitle[key],
                        "value": value.description
                    ]
                    
                    if let imageDict: [String: AnyObject] = keyToImageDictionary[key] {
                        dataDict["image"] = imageDict["image"] as String!
                        dataDict["imageTintColor"] = imageDict["tintColor"] as UIColor!
                    }
                    
                    keyValueCard.content.append(dataDict)
                    keyValueCard.sectionInset = defaultSectionInset
                }
            }
            
            if keyValueCard.content.count > 0 {
                appendCard(keyValueCard)
            }
        }
        
        // Add Tags Card
        var tagsCard = Card(cardType: .Tags, title: "Tags")
        tagsCard.content.append([
            ["name": "Python"],
            ["name": "Hacker"],
            ["name": "Swift"],
            ["name": "Investing"],
            ["name": "Startups"],
            ["name": "Apple Pay"],
            ["name": "Management"],
            ["name": "Influencer"],
        ])
        tagsCard.sectionInset = defaultSectionInset
        appendCard(tagsCard)
        
        // Add Notes Card
        var notesCard = Card(cardType: .Notes, title: "Notes")
        notesCard.content.append(["text": "This is a long sample note which should be at least two lines. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."])
        notesCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 55.0, 0.0)
        appendCard(notesCard)
        
        completionHandler(error: nil)
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is TagsCollectionViewCell {
            (cell as TagsCollectionViewCell).showTagsLabel = true
        }
    }
    
    // MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as ProfileHeaderCollectionReusableView
            
            if person != nil {
                supplementaryView.setPerson(person)
            }
            
            profileHeaderView = supplementaryView
            return supplementaryView
    }
    
    // MARK: - Cell Type
    
    func typeOfCell(indexPath: NSIndexPath) -> CellType {
        let card = cards[indexPath.section]
        if let rowDataDictionary = card.content[indexPath.row] as? [String: AnyObject] {
           return CellType.typeByKey(rowDataDictionary["key"] as String!)
        }
        
        return .Other
    }
    
}