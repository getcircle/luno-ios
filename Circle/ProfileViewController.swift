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
            for (title, value) in person.attributes() {
                attributesTitles.append(title)
                attributesValues.append(value)
            }
            self.collectionView.reloadData()
        }
    }
    
    var attributesTitles: [String] = []
    var attributesValues: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.customizeCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.translucent = true
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.translucent = false
            navigationBar.shadowImage = nil
            navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        }
    }

    private func customizeCollectionView() {
        self.collectionView.registerNib(
            UINib(nibName: "ProfileAttributeCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: ProfileAttributeCollectionViewCell.classReuseIdentifier)

        self.collectionView.registerNib(
            UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier)
    }
    
    // MARK: Data source
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attributesValues.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            ProfileAttributeCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath) as ProfileAttributeCollectionViewCell
        
        if attributesTitles.count > indexPath.row {
            cell.nameLabel.text = attributesTitles[indexPath.row]
            cell.valueLabel.text = attributesValues[indexPath.row]
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
    
    // MARK: Flow Layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.collectionView.bounds.width, 44.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(self.collectionView.bounds.width, 200.0)
    
    }
}

