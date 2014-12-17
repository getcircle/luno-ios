//
//  ChatRoomCollectionViewLayout.swift
//  Circle
//
//  Created by Michael Hahn on 12/1/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

class ChatRoomCollectionViewLayout: SpringFlowLayout {

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributes = super.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        // handle cell inversion from the SLKTextViewController
        for attribute in attributes {
            attribute.transform = collectionView!.transform
        }
        return attributes
    }
    
}
