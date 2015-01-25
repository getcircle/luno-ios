//
//  ProfileInfoCollectionView.swift
//  Circle
//
//  Created by Michael Hahn on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileInfoCollectionView: UnderlyingCollectionView {
    
    private var layout: StickyHeaderCollectionViewLayout?
    private var profile: ProfileService.Containers.Profile?
    private var profileInfoDataSource: ProfileDetailDataSource?
    private var profileInfoDelegate: StickyHeaderCollectionViewDelegate?
    
    convenience init(profile: ProfileService.Containers.Profile?) {
        let stickyLayout = StickyHeaderCollectionViewLayout()
        self.init(frame: CGRectZero, collectionViewLayout: stickyLayout)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        layout = stickyLayout
        layout?.headerHeight = ProfileHeaderCollectionReusableView.height
        profileInfoDataSource = ProfileDetailDataSource(profile: profile!)
        profileInfoDataSource?.registerCardHeader(self)
        profileInfoDelegate = StickyHeaderCollectionViewDelegate()
        backgroundColor = UIColor.viewBackgroundColor()
        dataSource = profileInfoDataSource
        delegate = profileInfoDelegate
        alwaysBounceVertical = true
        
        // XXX we should consider making this a public function so the view controller can instantiate an activity indicator and then call load data, clearing activity indicator when the content has loaded
        profileInfoDataSource?.loadData { (error) -> Void in
            self.reloadData()
        }
    }
    
}
