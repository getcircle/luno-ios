//
//  ExpandingHeaderCollectionViewLayout.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ExpandingHeaderCollectionViewLayout: UICollectionViewFlowLayout {
    
    let initialHeaderHeight: CGFloat = 200.0
    let cellHeight: CGFloat = 44.0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerClass(SeparatorDecorationView.self,
            forDecorationViewOfKind: SeparatorDecorationView.kind)

        registerClass(SpacerDecorationView.self,
            forDecorationViewOfKind: SpacerDecorationView.kind)
        
        sectionInset = UIEdgeInsetsZero
    }
    
    override func prepareLayout() {
        itemSize = CGSizeMake(collectionView!.bounds.width, cellHeight)
        headerReferenceSize = CGSizeMake(collectionView!.bounds.width, initialHeaderHeight)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {

        let contentOffset = self.collectionView!.contentOffset
        var attributes = super.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        
        var separatorViewYPositions = [CGFloat]()
        var spacerViewYPositions = [CGFloat]()
        
        for attribute in attributes {
            switch attribute.representedElementCategory {
            case .SupplementaryView:
                // Just stretching the header when scrolling down
                if attribute.representedElementKind == UICollectionElementKindSectionHeader && contentOffset.y <= 0 {
                    var frameToModify = attribute.frame
                    frameToModify.origin.y = contentOffset.y
                    frameToModify.size.height = max(initialHeaderHeight, initialHeaderHeight - contentOffset.y)
                    attribute.frame = frameToModify
                }
                
                // Add a spacer after every supplementary view
                spacerViewYPositions.append(attribute.frame.size.height + attribute.frame.origin.y)
                
            case .Cell:
                // Add a separator decoration view at the end of a cell
                attribute.frame.origin.y = attribute.frame.origin.y + 30.0
                separatorViewYPositions.append(attribute.frame.size.height + attribute.frame.origin.y)
                
            default:
                break
            }
        }

        // Add spacers
        for spacerViewYPosition in spacerViewYPositions {
            var decorationViewAttribute = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: SpacerDecorationView.kind,
                withIndexPath: NSIndexPath(index: 0))
            decorationViewAttribute.frame = CGRectMake(0.0, spacerViewYPosition, self.collectionView!.frame.size.width, 30.0)
            attributes.append(decorationViewAttribute)
        }
        
        // Add separators
        for separatorViewYPosition in separatorViewYPositions {
            var decorationViewAttribute = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: SeparatorDecorationView.kind,
                withIndexPath: NSIndexPath(index: 0))
            decorationViewAttribute.frame = CGRectMake(0.0, separatorViewYPosition, self.collectionView!.frame.size.width, 0.5)
            attributes.append(decorationViewAttribute)
        }
        
        return attributes
    }
}
