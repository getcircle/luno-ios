//
//  TagScrollingCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

struct TagScrollingCollectionViewCellNotifications {
    static let onTagSelectedNotification = "com.rhlabs.notification:onTagSelectedNotification"
}

class TagScrollingCollectionViewCell: CircleCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    override class var classReuseIdentifier: String {
        return "TagScrollingCollectionViewCell"
    }

    override class var height: CGFloat {
        return 90.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    var prototypeCell: TagCollectionViewCell!
    
    // pass backgroundColor changes to the collectionView
    override var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = backgroundColor
            collectionView?.backgroundColor = backgroundColor
        }
    }
    
    var selectedTag: Services.Profile.Containers.TagV1?
    private var interests = Array<Services.Profile.Containers.TagV1>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureCollectionView()
        configurePrototypeCell()
        selectedBackgroundView = nil
    }

    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.bounces = false
        collectionView.registerNib(
            UINib(nibName: "TagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: TagCollectionViewCell.classReuseIdentifier
        )
    }
    
    private func configurePrototypeCell() {
        // Init prototype cell
        let cellNibViews = NSBundle.mainBundle().loadNibNamed("TagCollectionViewCell", owner: self, options: nil)
        prototypeCell = cellNibViews.first as TagCollectionViewCell
    }

    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let interest = interests[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TagCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as TagCollectionViewCell
        
        cell.interestLabel.text = interest.name
        cell.interestLabel.backgroundColor = collectionView.backgroundColor
        cell.backgroundColor = collectionView.backgroundColor
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let interest = interests[indexPath.row]

        prototypeCell.interestLabel.text = interest.name
        prototypeCell.setNeedsLayout()
        prototypeCell.layoutIfNeeded()
        let intrinsicSize = prototypeCell.intrinsicContentSize()
        return CGSizeMake(intrinsicSize.width, 40.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let interest = interests[indexPath.row]
        selectedTag = interest
        NSNotificationCenter.defaultCenter().postNotificationName(
            TagScrollingCollectionViewCellNotifications.onTagSelectedNotification,
            object: nil,
            userInfo: ["interest": interest]
        )
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        selectedTag = nil
    }
    
    // MARK: - Data Setter
    
    override func setData(data: AnyObject) {
        if let arrayOfTags = data as? [Services.Profile.Containers.TagV1] {
            interests = arrayOfTags
            collectionView.reloadData()
        }
    }
    
    // MARK: - Sizing
    
    override func intrinsicContentSize() -> CGSize {
        let collectionViewLayout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        let height = collectionViewLayout.collectionViewContentSize().height
        return CGSizeMake(CircleCollectionViewCell.width, height)
    }
}
