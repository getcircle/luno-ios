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
        "linkedin": [
            "image": "LinkedIn",
            "tintColor": UIColor.linkedinColor(),
        ],
        "github": [
            "image": "Twitter",
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
    
    private var dataSourceKeys = [AnyObject]()
    
    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier
        )
        
        super.registerCardHeader(collectionView)
    }

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        for dataSet in [baseInfoKeySet, socialInfoKeySet, managerInfoKeySet] {
            var keyValueCard = Card(cardType: .KeyValue, title: "Info")
            for key in dataSet {
                if let value: AnyObject = self.person.valueForKey(key) {
                    var dataDict: [String: AnyObject!] = [
                        "key": keyToTitle[key],
                        "value": value.description
                    ]
                    
                    if let imageDict: [String: AnyObject] = keyToImageDictionary[key] {
                        dataDict["image"] = imageDict["image"] as String!
                        dataDict["imageTintColor"] = imageDict["tintColor"] as UIColor!
                    }
                    
                    keyValueCard.content.append(dataDict)
                }
            }
            
            if keyValueCard.content.count > 0 {
                appendCard(keyValueCard)
            }
        }
        
        completionHandler(error: nil)
    }

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
    
    func typeOfCell(indexPath: NSIndexPath) -> CellType {
        if let key = dataSourceKeys[indexPath.section][indexPath.item] as? String {
            return CellType.typeByKey(key)
        }
        
        return .Other
    }
    
}