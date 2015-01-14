//
//  CenterAlignFlowLayout.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class CenterAlignFlowLayout: UICollectionViewFlowLayout {

    private var cachedItemFrames = [NSIndexPath: CGRect]()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        minimumInteritemSpacing = 10.0
        sectionInset = UIEdgeInsetsMake(0.0, 10.0, 50.0, 10.0)
        minimumLineSpacing = 10.0
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        let currentAttributes = super.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        
        // Collect item attributes by row
        var itemAttributesByRow = [CGFloat: [UICollectionViewLayoutAttributes]]()
        for itemAttributes in currentAttributes {
//            if let finalFrame = cachedItemFrames[itemAttributes.indexPath] {
//                itemAttributes.frame = finalFrame
//            }
//            else {
                let centerY = CGRectGetMidY(itemAttributes.frame)
                if itemAttributesByRow[centerY] == nil {
                    itemAttributesByRow[centerY] = [UICollectionViewLayoutAttributes]()
                }
                
                itemAttributesByRow[centerY]!.append(itemAttributes)
//            }
        }
        
        // Update frames to center them
        for (perRowCenterY, perRowItemsAttributes) in itemAttributesByRow {
        
            // Figure out the starting X co-ordinate of the first item
            let totalSpacing = minimumInteritemSpacing * (CGFloat(perRowItemsAttributes.count) - 1.0)
            let totalItemWidths = perRowItemsAttributes.reduce(0.0) {
                $0 + CGRectGetWidth(($1 as UICollectionViewLayoutAttributes).frame)
            }
            
            let startingX = (collectionView!.frameWidth - totalSpacing - totalItemWidths) / 2.0
            var previousFrame = CGRectZero
            for itemAttributes in perRowItemsAttributes {
                
                var itemFrame = itemAttributes.frame
                if CGRectEqualToRect(previousFrame, CGRectZero) {
                    itemFrame.origin.x = startingX
                }
                else {
                    itemFrame.origin.x = CGRectGetMaxX(previousFrame) + minimumInteritemSpacing
                }
                
                itemAttributes.frame = itemFrame
                cachedItemFrames[itemAttributes.indexPath] = itemFrame
                previousFrame = itemAttributes.frame
            }
        }
        
        return currentAttributes
    }
}
