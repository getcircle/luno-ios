//
//  ProfilesCollectionViewDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 1/7/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class ProfilesCollectionViewDelegate: CardCollectionViewDelegate {
   
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1.0, 0.0, 25.0, 0.0)
    }
}
