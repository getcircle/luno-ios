//
//  TagsCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

struct TagsCollectionViewCellNotifications {
    static let onTagSelectedNotification = "com.ravcode.notification:onTagSelectedNotification"
}

class TagsCollectionViewCell: CircleCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    override class var classReuseIdentifier: String {
        return "TagsCollectionViewCell"
    }

    override class var height: CGFloat {
        return 90.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private var collectionViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak private var tagsLabel: UILabel!
    
    var prototypeCell: TagCollectionViewCell!
    var showTagsLabel: Bool = false {
        didSet {
            if showTagsLabel {
                tagsLabel.hidden = false
                collectionViewTopSpaceConstraint.constant = 31.0
            }
            else {
                tagsLabel.hidden = true
                collectionViewTopSpaceConstraint.constant = 0.0
            }
        }
    }
    
    var selectedTag: ProfileService.Containers.Tag?
    private var tags = Array<ProfileService.Containers.Tag>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        showTagsLabel = false
        configureCollectionView()
        configurePrototypeCell()
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
        return tags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let tag = tags[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TagCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as TagCollectionViewCell
        
        cell.tagLabel.text = tag.name
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let tag = tags[indexPath.row]

        prototypeCell.tagLabel.text = tag.name
        prototypeCell.setNeedsLayout()
        prototypeCell.layoutIfNeeded()
        return prototypeCell.intrinsicContentSize()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if showTagsLabel {
            // Algin tags with the label if the label is shown
            return UIEdgeInsetsMake(10.0, tagsLabel.frameX, 10.0, tagsLabel.frameX)
        }
        else {
            return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        }
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let tag = tags[indexPath.row]
        selectedTag = tag
        NSNotificationCenter.defaultCenter().postNotificationName(
            TagsCollectionViewCellNotifications.onTagSelectedNotification,
            object: nil,
            userInfo: ["tag": tag]
        )
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        selectedTag = nil
    }
    
    // MARK: - Data Setter
    
    override func setData(data: AnyObject) {
        if let arrayOfTags = data as? [ProfileService.Containers.Tag] {
            tags = arrayOfTags
            collectionView.reloadData()
        }
    }
    
    // MARK: - Sizing
    
    override func intrinsicContentSize() -> CGSize {
        let collectionViewLayout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        let height = collectionViewLayout.collectionViewContentSize().height + collectionViewTopSpaceConstraint.constant
        return CGSizeMake(CircleCollectionViewCell.width, height)
    }
}
