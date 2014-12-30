//
//  TagCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class TagCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var tagLabel: PaddedLabel!

    override class var classReuseIdentifier: String {
        return "TagCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 30.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        tagLabel.textColor = UIColor.defaultDarkTextColor()
        tagLabel.layer.borderColor = UIColor.tagNormalBorderColor().CGColor
        tagLabel.layer.borderWidth = 1.0
        tagLabel.paddingEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return tagLabel.intrinsicContentSize()
    }

    override func setData(data: AnyObject) {
        if let tagsDictionary = data as? [String: String] {
            tagLabel.text = tagsDictionary["name"]
        }
    }

    // MARK: - Appearance Animation
    
    func animateForCollection(collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) {
        let originalFrame = frame
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
        frame = cellFrame
        alpha = 0.0
        
        UIView.animateWithDuration(0.2,
            delay: 0.01 * Double(indexPath.row),
            options: .CurveEaseIn,
            animations: { () -> Void in
                self.frame = originalFrame
                self.alpha = 1.0
            },
            completion: nil
        )
    }
    
    // MARK: - State updates
    
    func selectCell(animated: Bool) {
        let duration = animated ? 0.2 : 0.0
        
        layer.zPosition = 10
        UIView.animateWithDuration(
            duration,
            animations: { () -> Void in
                self.tagLabel.backgroundColor = UIColor.tagSelectedBackgroundColor()
                self.tagLabel.textColor = UIColor.defaultLightTextColor()
                if animated {
                    // Scaling animates even if the duration is set to 0. So, scale only
                    // when animated is set
                    self.transform = CGAffineTransformMakeScale(1.2, 1.2)
                }
                self.tagLabel.layer.borderColor = UIColor.tagSelectedBorderColor().CGColor
            },
            completion: { (completed) -> Void in
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.transform = CGAffineTransformIdentity
                })
            }
        )
    }
    
    func highlightCell(animated: Bool) {
        let duration = animated ? 0.2 : 0.0
        
        if self.tagLabel.backgroundColor == UIColor.tagSelectedBackgroundColor() {
            return
        }
        
        UIView.animateWithDuration(
            duration,
            animations: { () -> Void in
                self.tagLabel.backgroundColor = UIColor.tagSelectedBackgroundColor()
                self.tagLabel.textColor = UIColor.defaultLightTextColor()
                self.tagLabel.layer.borderColor = UIColor.tagSelectedBorderColor().CGColor
            }
        )
    }
    
    func unHighlightCell(animated: Bool) {
        let duration = animated ? 0.2 : 0.0
        
        if self.tagLabel.backgroundColor == UIColor.tagNormalBackgroundColor() {
            return
        }

        layer.zPosition = 0
        UIView.animateWithDuration(
            duration,
            animations: { () -> Void in
                self.tagLabel.backgroundColor = UIColor.tagNormalBackgroundColor()
                self.tagLabel.textColor = UIColor.defaultDarkTextColor()
                self.tagLabel.layer.borderColor = UIColor.tagNormalBorderColor().CGColor
            }
        )
    }
}
