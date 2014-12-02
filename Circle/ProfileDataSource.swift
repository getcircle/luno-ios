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
    
    private (set) var profileHeaderView: ProfileHeaderCollectionReusableView?
    var attributes: [String] = []
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
    ]
    
    var dataSourceKeys = [AnyObject]()
    
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
    
}