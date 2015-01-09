//
//  ProfileCollectionViewLayout.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class ProfileCollectionViewLayout: UICollectionViewFlowLayout {
    
    class var profileHeaderHeight: CGFloat {
        return 200.0
    }
    
    // 44.0 height of nav bar + 20.0 height of status bar
    let offsetToMakeProfileHeaderSticky: CGFloat = ProfileCollectionViewLayout.profileHeaderHeight - 64.0
    let cellHeight: CGFloat = 44.0
    
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
        itemSize = CGSizeMake(collectionView!.bounds.width - sectionInset.left - sectionInset.right, cellHeight)
        headerReferenceSize = CGSizeMake(collectionView!.bounds.width, ProfileCollectionViewLayout.profileHeaderHeight)
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
                
                if attribute.indexPath.section != 0 {
                    attribute.hidden = true
                }
                else if attribute.representedElementKind == UICollectionElementKindSectionHeader {
                    if contentOffset.y <= 0 {
                        // Stretch the header when scrolling down
                        var frameToModify = attribute.frame
                        frameToModify.origin.y = contentOffset.y
                        frameToModify.size.height = max(
                            ProfileCollectionViewLayout.profileHeaderHeight,
                            ProfileCollectionViewLayout.profileHeaderHeight - contentOffset.y)
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
