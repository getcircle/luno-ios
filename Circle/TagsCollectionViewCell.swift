//
//  TagsCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class TagsCollectionViewCell: CircleCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    override class var classReuseIdentifier: String {
        return "TagsCollectionViewCell"
    }

    override class var height: CGFloat {
        return 90.0
    }
    
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    private var tags = [[String: String]]()
    var prototypeCell: TagCollectionViewCell!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureCollectionView()
        configurePrototypeCell()
    }

    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
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
        
        cell.tagLabel.text = tag["name"]
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let tag = tags[indexPath.row]

        prototypeCell.tagLabel.text = tag["name"]
        prototypeCell.setNeedsLayout()
        prototypeCell.layoutIfNeeded()
        return prototypeCell.intrinsicContentSize()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let tag = tags[indexPath.row]["name"]
        println("SELECTED \(tag)")
    }
    
    // MARK: - Data Setter
    
    override func setData(data: AnyObject) {
        if let arrayOfTagsDictionary = data as? [[String: String]] {
            tags = arrayOfTagsDictionary
            collectionView.reloadData()
        }
    }
}