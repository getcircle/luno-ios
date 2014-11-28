//
//  ProfileViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var person: Person! {
        didSet {
            // Update the view.
            attributes = person.attributes()
            self.collectionView.reloadData()
        }
    }
    
    var attributes: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        customizeCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.makeTransparent()
    }
    
    override func viewWillDisappear(animated: Bool) {
       navigationController?.navigationBar.makeOpaque()
    }

    private func customizeCollectionView() {
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        collectionView.registerNib(
            UINib(nibName: "ProfileAttributeCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: ProfileAttributeCollectionViewCell.classReuseIdentifier)

        collectionView.registerNib(
            UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier)
    }
    
    // MARK: Data source
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attributes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            ProfileAttributeCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath) as ProfileAttributeCollectionViewCell
        
        if person.attributeTitles.count > indexPath.row {
            cell.nameLabel.text = person.attributeTitles[indexPath.row]
            cell.valueLabel.text = attributes[indexPath.row]
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            
        let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath) as ProfileHeaderCollectionReusableView
            
        if person != nil {
            supplementaryView.setPerson(person)
        }
        
        return supplementaryView
    }
}

