//
//  TagSelectorCollectionViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class TagSelectorCollectionViewController: UICollectionViewController {

    let tags = ["python", "mysql", "investing", "french", "ios", "swift", "business development", "private equity", "personal finance", "C", "C++", "product", "design"]
    var prototypeCell: TagCollectionViewCell!
    var animatedCell = [NSIndexPath: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init prototype cell
        let cellNibViews = NSBundle.mainBundle().loadNibNamed("TagCollectionViewCell", owner: self, options: nil)
        prototypeCell = cellNibViews.first as TagCollectionViewCell
        
        // Configurations
        configureCollectionView()
    }

    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView?.registerNib(
            UINib(nibName: "TagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: TagCollectionViewCell.classReuseIdentifier
        )
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TagCollectionViewCell.classReuseIdentifier, forIndexPath: indexPath) as TagCollectionViewCell
    
        // Configure the cell
        cell.tagLabel.text = tags[indexPath.row].capitalizedString
        
        if animatedCell[indexPath] == nil {
            animatedCell[indexPath] = true
            let originalFrame = cell.frame
            var cellFrame = originalFrame
            let collectionViewMidX = CGRectGetMidX(collectionView.frame)
            if CGRectGetMinX(cellFrame) < collectionViewMidX {
                // Animate from left
                cellFrame.origin.x -= 20.0
            }
            else {
                // Animate from right
                cellFrame.origin.x += 20.0
            }
            cell.frame = cellFrame
            cell.alpha = 0.0
            
            UIView.animateWithDuration(0.3,
                delay: 0.02 * Double(indexPath.row),
                options: .CurveEaseIn,
                animations: { () -> Void in
                    cell.frame = originalFrame
                    cell.alpha = 0.8
                },
                completion: nil
            )
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        prototypeCell.tagLabel.text = tags[indexPath.row].capitalizedString
        prototypeCell.setNeedsLayout()
        prototypeCell.layoutIfNeeded()
        return prototypeCell.intrinsicContentSize()
    }

    // MARK: - IBActions
    
    @IBAction func close(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
