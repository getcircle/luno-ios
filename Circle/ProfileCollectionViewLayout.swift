//
//  ProfileCollectionViewLayout.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class ProfileCollectionViewLayout: UICollectionViewFlowLayout {
    
    var headerHeight: CGFloat = 0.0
    var offsetToMakeProfileHeaderSticky: CGFloat!
    let cellHeight: CGFloat = 44.0
    
    override init() {
        super.init()
        registerClass(
            SeparatorDecorationView.self,
            forDecorationViewOfKind: SeparatorDecorationView.kind
        )
        
        sectionInset = UIEdgeInsetsMake(30.0, 0.0, 0.0, 0.0)
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerClass(
            SeparatorDecorationView.self,
            forDecorationViewOfKind: SeparatorDecorationView.kind
        )
        
        sectionInset = UIEdgeInsetsMake(30.0, 0.0, 0.0, 0.0)
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
    }
    
    override func prepareLayout() {
        if headerHeight == 0.0 {
            println("headerHeight should be set to greater than zero")
        }

        // 44.0 height of nav bar + 20.0 height of status bar
        offsetToMakeProfileHeaderSticky = headerHeight - 64.0
        itemSize = CGSizeMake(collectionView!.bounds.width - sectionInset.left - sectionInset.right, cellHeight)
        headerReferenceSize = CGSizeMake(collectionView!.bounds.width, headerHeight)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {

        let contentOffset = collectionView!.contentOffset
        var attributes = super.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        
        for attribute in attributes {
            switch attribute.representedElementCategory {
            case .SupplementaryView:
                
                if attribute.representedElementKind == UICollectionElementKindSectionHeader && attribute.indexPath.section == 0 {
                    if contentOffset.y <= 0 {
                        // Stretch the header when scrolling down
                        var frameToModify = attribute.frame
                        frameToModify.origin.y = contentOffset.y
                        frameToModify.size.height = max(
                            headerHeight,
                            headerHeight - contentOffset.y)
                        attribute.frame = frameToModify
                    }
                    else {
                        // Pin supplementary view to the top after it reaches nav bar height
                        var frameToModify = attribute.frame
                        frameToModify.origin.y = max(0.0, contentOffset.y - offsetToMakeProfileHeaderSticky)
                        attribute.frame = frameToModify
                        attribute.zIndex = 100
                    }
                }

            default:
                break
            }
        }
        
        return attributes
    }
}
