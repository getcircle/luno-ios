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
        
        let activityIndicatorView = addActivityIndicator()
        profileInfoDataSource?.loadData { (error) -> Void in
            activityIndicatorView.stopAnimating()            
            self.reloadData()
        }
    }
    
}
