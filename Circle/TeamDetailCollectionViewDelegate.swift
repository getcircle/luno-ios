//
//  TeamDetailCollectionViewDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 1/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class TeamDetailCollectionViewDelegate: StickyHeaderCollectionViewDelegate {

    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 2 {
            return CGSizeMake(collectionView.frame.size.width, 45.0)
        }

        return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
    }
}
