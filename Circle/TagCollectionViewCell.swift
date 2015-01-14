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
    
    var defaultTextColor = UIColor.defaultDarkTextColor()
    var defaultBackgroundColor = UIColor.tagNormalBackgroundColor()
    var defaultBorderColor = UIColor.tagNormalBorderColor()

    var highlightedTextColor = UIColor.defaultLightTextColor()
    var highlightedBackgroundColor = UIColor.tagSelectedBackgroundColor()
    var highlightedBorderColor = UIColor.tagSelectedBorderColor()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        tagLabel.textColor = defaultTextColor
        tagLabel.layer.borderColor = defaultBorderColor.CGColor
        tagLabel.layer.borderWidth = 1.0
        layer.shouldRasterize = true;
        layer.rasterizationScale = UIScreen.mainScreen().scale;
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
            delay: 0.001 * Double(indexPath.row),
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
                self._selectCell()
                if animated {
                    // Scaling animates even if the duration is set to 0. So, scale only
                    // when animated is set
                    self.transform = CGAffineTransformMakeScale(1.2, 1.2)
                }
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
        
        if tagLabel.backgroundColor == highlightedBackgroundColor {
            return
        }
        
        UIView.animateWithDuration(
            duration,
            animations: { () -> Void in
                self._selectCell()
            }
        )
    }
    
    func unHighlightCell(animated: Bool) {
        let duration = animated ? 0.2 : 0.0
        
        if tagLabel.backgroundColor == defaultBackgroundColor {
            return
        }

        layer.zPosition = 0
        UIView.animateWithDuration(
            duration,
            animations: { () -> Void in
                self.tagLabel.textColor = self.defaultTextColor
                self.tagLabel.backgroundColor = self.defaultBackgroundColor
                self.tagLabel.layer.borderColor = self.defaultBorderColor.CGColor
            }
        )
    }
    
    // MARK: - Helpers
    
    private func _selectCell() {
        tagLabel.textColor = highlightedTextColor
        tagLabel.backgroundColor = highlightedBackgroundColor
        tagLabel.layer.borderColor = highlightedBorderColor.CGColor
    }
}
