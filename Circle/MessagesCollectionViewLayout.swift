//
//  MessagesCollectionViewLayout.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class MessagesCollectionViewLayout: UICollectionViewFlowLayout {
    
    let cellHeight: CGFloat = 64.0
    
    override func prepareLayout() {
        self.minimumInteritemSpacing = 0.0
        self.minimumLineSpacing = 0.0
        self.registerClass(SeparatorDecorationView.self, forDecorationViewOfKind: SeparatorDecorationView.kind)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributes = super.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        return self.addSeparatorsToCells(attributes)
    }
    
}
