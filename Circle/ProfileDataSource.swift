//
//  ProfileDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ProfileDataSource: NSObject, UICollectionViewDataSource {

    var person: Person!
    var attributes: [String] = []
    let baseInfoKeySet = [
        "email",
        "cell",
        "location",
        "country"
    ]
    let managerInfoKeySet = [
        "manager"
    ]

    let keyToTitle = [
        "email": "Email",
        "cell": "Cell Phone",
        "location": "City",
        "country": "Country",
        "manager": "Manager"
    ]
    
    var dataSourceKeys = [AnyObject]()
    
    required init(person: Person) {
        super.init()
        self.person = person
        fillData()
    }
    
    private func fillData() {
        dataSourceKeys.append(baseInfoKeySet)
        if person.hasManager {
            dataSourceKeys.append(managerInfoKeySet)
        }
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
            if let value: AnyObject = person.objectForKey(key) {
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
            
            return supplementaryView
    }
    
}