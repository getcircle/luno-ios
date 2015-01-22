//
//  StickyHeaderCollectionViewLayout.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class StickyHeaderCollectionViewLayout: UICollectionViewFlowLayout {
    
    var headerHeight: CGFloat = 0.0
    
    private var offsetToMakeHeaderSticky: CGFloat = 0.0
    private var cellHeight: CGFloat = 44.0
    
    override init() {
        super.init()
        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        registerClass(SeparatorDecorationView.self, forDecorationViewOfKind: SeparatorDecorationView.kind)
        sectionInset = UIEdgeInsetsMake(30.0, 0.0, 0.0, 0.0)
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
    }
    
    override func prepareLayout() {
        if headerHeight == 0.0 {
            println("headerHeight should be set to greater than zero")
        }

        // 44.0 height of nav bar
        offsetToMakeHeaderSticky = headerHeight - 44.0
        itemSize = CGSizeMake(collectionView!.bounds.width - sectionInset.left - sectionInset.right, cellHeight)
        headerReferenceSize = CGSizeMake(collectionView!.bounds.width, headerHeight)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {

        let contentOffset = collectionView!.contentOffset
        var attributes = super.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        
        var isHeaderMissing = true
        for attribute in attributes {
            if attribute.representedElementCategory == .SupplementaryView && attribute.representedElementKind == UICollectionElementKindSectionHeader && attribute.indexPath.section == 0 {
                isHeaderMissing = false
            }
        }
        
        if isHeaderMissing {
            attributes.append(super.layoutAttributesForSupplementaryViewOfKind(
                UICollectionElementKindSectionHeader,
                atIndexPath: NSIndexPath(forItem: 0, inSection: 0)
            ))
        }
        
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
                        frameToModify.origin.y = max(0.0, contentOffset.y - offsetToMakeHeaderSticky)
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