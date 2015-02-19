//
//  OfficesOverviewCollectionViewDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 1/24/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class OfficesOverviewCollectionViewDelegate: CardCollectionViewDelegate {

    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let card = cardDataSource(collectionView).cardAtSection(section) {
            return card.headerSize
        }
        
        return CGSizeZero
    }
}
