//
//  SkillCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class SkillCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var skillLabel: PaddedLabel!

    override class var classReuseIdentifier: String {
        return "SkillCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 35.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    var defaultTextColor = UIColor.defaultDarkTextColor()
    var defaultBackgroundColor = UIColor.skillNormalBackgroundColor()
    var defaultBorderColor = UIColor.skillNormalBorderColor()

    var highlightedTextColor = UIColor.defaultLightTextColor()
    var highlightedBackgroundColor = UIColor.skillSelectedBackgroundColor()
    var highlightedBorderColor = UIColor.skillSelectedBorderColor()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        skillLabel.textColor = defaultTextColor
        skillLabel.layer.borderColor = defaultBorderColor.CGColor
        skillLabel.layer.borderWidth = 1.0
        skillLabel.paddingEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
        bringSubviewToFront(selectedBackgroundView)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(skillLabel.intrinsicContentSize().width, 35.0)
    }

    override func setData(data: AnyObject) {
        if let skillsDictionary = data as? [String: String] {
            skillLabel.text = skillsDictionary["name"]
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
        
        if skillLabel.backgroundColor == highlightedBackgroundColor {
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
        
        if skillLabel.backgroundColor == defaultBackgroundColor {
            return
        }

        layer.zPosition = 0
        UIView.animateWithDuration(
            duration,
            animations: { () -> Void in
                self.skillLabel.textColor = self.defaultTextColor
                self.skillLabel.backgroundColor = self.defaultBackgroundColor
                self.skillLabel.layer.borderColor = self.defaultBorderColor.CGColor
            }
        )
    }
    
    // MARK: - Helpers
    
    private func _selectCell() {
        skillLabel.textColor = highlightedTextColor
        skillLabel.backgroundColor = highlightedBackgroundColor
        skillLabel.layer.borderColor = highlightedBorderColor.CGColor
        
        // If the call gets here, it implies we are using custom selection
        selectedBackgroundView = nil
    }
}
