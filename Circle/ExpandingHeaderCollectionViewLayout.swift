//
//  ExpandingHeaderCollectionViewLayout.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ExpandingHeaderCollectionViewLayout: UICollectionViewFlowLayout {
    
    class var profileHeaderHeight: CGFloat {
        return 200.0
    }
    
    let cellHeight: CGFloat = 44.0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerClass(SeparatorDecorationView.self,
            forDecorationViewOfKind: SeparatorDecorationView.kind)
        
        sectionInset = UIEdgeInsetsMake(30.0, 0.0, 0.0, 0.0)
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
    }
    
    override func prepareLayout() {
        itemSize = CGSizeMake(collectionView!.bounds.width, cellHeight)
        headerReferenceSize = CGSizeMake(collectionView!.bounds.width, ExpandingHeaderCollectionViewLayout.profileHeaderHeight)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {

        let contentOffset = self.collectionView!.contentOffset
        var attributes = super.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        
        var separatorViewYPositions = [CGFloat]()
        var separatorViewIndexPaths = [NSIndexPath]()
        
        for attribute in attributes {
            switch attribute.representedElementCategory {
            case .SupplementaryView:
                
                if attribute.indexPath.section != 0 {
                    attribute.hidden = true
                }
                else if attribute.representedElementKind == UICollectionElementKindSectionHeader && contentOffset.y <= 0 {
                    
                    // Stretch the header when scrolling down
                    var frameToModify = attribute.frame
                    frameToModify.origin.y = contentOffset.y
                    frameToModify.size.height = max(
                        ExpandingHeaderCollectionViewLayout.profileHeaderHeight,
                        ExpandingHeaderCollectionViewLayout.profileHeaderHeight - contentOffset.y)
                    attribute.frame = frameToModify
                }
                
            case .Cell:
                // Add a separator decoration view at the end of a cell
                separatorViewYPositions.append(attribute.frame.size.height + attribute.frame.origin.y)
                separatorViewIndexPaths.append(NSIndexPath(forItem: attribute.indexPath.item + 1, inSection: attribute.indexPath.section))
                
            default:
                break
            }
        }
        
        // Add separators
        for index in 0..<separatorViewYPositions.count {
            var decorationViewAttribute = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: SeparatorDecorationView.kind,
                withIndexPath: separatorViewIndexPaths[index]
            )
            decorationViewAttribute.frame = CGRectMake(0.0, separatorViewYPositions[index], self.collectionView!.frame.size.width, 0.5)
            attributes.append(decorationViewAttribute)
        }
        
        return attributes
    }
}
