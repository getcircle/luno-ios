//
//  ProfileDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ProfileDataSource: NSObject, UICollectionViewDataSource {

    var person: Person! {
        didSet {
            fillData()
        }
    }

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
    
    convenience init(person: Person) {
        self.init()
        self.person = person
    }
    
    private func fillData() {
        dataSourceKeys.removeAll()
        for dataSet in [baseInfoKeySet, socialInfoKeySet, managerInfoKeySet] {
            dataSourceKeys.append(dataSet.filter({ self.person.valueForKey($0) != nil }))
        }
        
        // Remove any sets that did not have any elements with a non-nil value
        dataSourceKeys = dataSourceKeys.filter({ $0.count != 0 })
    }
    
    // MARK: - Collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSourceKeys.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceKeys[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            ProfileAttributeCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath) as ProfileAttributeCollectionViewCell
        
        if let key = dataSourceKeys[indexPath.section][indexPath.item] as? String {
            if let value: AnyObject = person.valueForKey(key) {
                cell.nameLabel.text = keyToTitle[key]
                cell.valueLabel.text = value.description
                
                if let imageDict: [String: AnyObject] = keyToImageDictionary[key] {
                    cell.nameImageView.alpha = 1.0
                    cell.valueLabelTrailingSpaceConstraint.constant = 60.0
                    cell.nameImageView.image = UIImage(named: (imageDict["image"] as String!))?.imageWithRenderingMode(.AlwaysTemplate)
                    cell.nameImageView.tintColor = imageDict["tintColor"] as UIColor!
                }
                else {
                    cell.nameImageView.alpha = 0.0
                    cell.valueLabelTrailingSpaceConstraint.constant = 15.0
                }
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
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