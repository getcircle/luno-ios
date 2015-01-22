//
//  ProfileUnderlyingCollectionView.swift
//  Circle
//
//  Created by Michael Hahn on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileUnderlyingCollectionViewDataSource: CardDataSource {
    
    private var profile: ProfileService.Containers.Profile?
    
    convenience init(profile withProfile: ProfileService.Containers.Profile) {
        self.init()
        profile = withProfile
    }
    
    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier
        )
        super.registerCardHeader(collectionView)
    }
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        let placeholderCard = Card(cardType: .Placeholder, title: "Placeholder")
        appendCard(placeholderCard)
    }
    
    override func collectionView(
        collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath
    ) -> UICollectionReusableView {
            
        if indexPath.section == 0 {
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as ProfileHeaderCollectionReusableView
            if profile != nil {
                supplementaryView.setProfile(profile!)
            }
            return supplementaryView
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
    
}

class ProfileUnderlyingCollectionView: UICollectionView {
    
    private var layout: StickyHeaderCollectionViewLayout?
    private var profile: ProfileService.Containers.Profile?
    private var collectionViewDataSource: ProfileUnderlyingCollectionViewDataSource?
    private var collectionViewDelegate: StickyHeaderCollectionViewDelegate?
    
    convenience init(profile: ProfileService.Containers.Profile?) {
        let stickyLayout = StickyHeaderCollectionViewLayout()
        self.init(frame: CGRectZero, collectionViewLayout: stickyLayout)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        layout = stickyLayout
        layout?.headerHeight = 200.0
        collectionViewDataSource = ProfileUnderlyingCollectionViewDataSource(profile: AuthViewController.getLoggedInUserProfile()!)
        collectionViewDataSource?.registerCardHeader(self)
        collectionViewDelegate = StickyHeaderCollectionViewDelegate()
        backgroundColor = UIColor.viewBackgroundColor()
        dataSource = collectionViewDataSource
        delegate = collectionViewDelegate
        alwaysBounceVertical = true
        
        // XXX we should consider making this a public function so the view controller can instantiate an activity indicator and then call load data, clearing activity indicator when the content has loaded
        collectionViewDataSource?.loadData { (error) -> Void in
            self.reloadData()
        }
    }

}
