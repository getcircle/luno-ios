//
//  UnderlyingCollectionViewDataSource.swift
//  Circle
//
//  Created by Michael Hahn on 1/25/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

private let EmptyHeaderReuseIdentifier = "EmptyHeaderReuseIdentifier"

class UnderlyingCollectionViewDataSource: CardDataSource {
    
    override func registerCardHeader(collectionView: UICollectionView) {
        super.registerCardHeader(collectionView)
        collectionView.registerClass(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: EmptyHeaderReuseIdentifier
        )
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: EmptyHeaderReuseIdentifier,
                forIndexPath: indexPath
                ) as UICollectionReusableView
            supplementaryView.backgroundColor = UIColor.clearColor()
            return supplementaryView
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
}
