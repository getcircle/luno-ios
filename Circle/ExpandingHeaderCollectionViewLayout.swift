//
//  ExpandingHeaderCollectionViewLayout.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ExpandingHeaderCollectionViewLayout: UICollectionViewFlowLayout {

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {

        let contentOffset = self.collectionView!.contentOffset
        var attributes = super.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        
        if contentOffset.y <= 0 {
            let initialHeaderHeight: CGFloat = 200.0
            for attribute in attributes {
                if attribute.representedElementCategory == .SupplementaryView {
                    if attribute.representedElementKind == UICollectionElementKindSectionHeader {
                        var frameToModify = attribute.frame
                        frameToModify.origin.y = contentOffset.y
                        frameToModify.size.height = max(initialHeaderHeight, initialHeaderHeight - contentOffset.y)
                        attribute.frame = frameToModify
                    }
                }
            }
        }
        
        return attributes
    }
}
