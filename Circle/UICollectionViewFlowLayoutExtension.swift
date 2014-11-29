//
//  UICollectionViewFlowLayoutExtension.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    func addSeparatorsToCells(layoutAttributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        var attributes = layoutAttributes
        
        var separatorViewYPositions = [CGFloat]()
        var separatorViewIndexPaths = [NSIndexPath]()
        
        for attribute in attributes {
            switch attribute.representedElementCategory {
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