//
//  ProfileCollectionViewDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 1/4/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class ProfileCollectionViewDelegate: CardCollectionViewDelegate {

    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(collectionView.frame.size.width, ProfileCollectionViewLayout.profileHeaderHeight)
        }
        
        return CGSizeZero
    }
}