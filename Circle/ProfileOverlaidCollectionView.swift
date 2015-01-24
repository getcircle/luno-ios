//
//  ProfileOverlaidCollectionView.swift
//  Circle
//
//  Created by Michael Hahn on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileOverlaidCollectionViewDataSource: CardDataSource {
    
    var profileHeaderView: ProfileHeaderCollectionReusableView?
    private var profile: ProfileService.Containers.Profile?
    private var sections: [String]?
    
    convenience init(profile withProfile: ProfileService.Containers.Profile, sections withSections: [String]?) {
        self.init()
        profile = withProfile
        sections = withSections
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
            profileHeaderView?.userInteractionEnabled = true
            if let subviews = profileHeaderView?.subviews as? [UIView] {
                for view in subviews {
                    view.userInteractionEnabled = true
                }
            }
            profileHeaderView = supplementaryView
            profileHeaderView?.sections = sections
            return supplementaryView
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
    
}

class ProfileOverlaidCollectionView: UICollectionView, UICollectionViewDelegate {
    
    override var delegate: UICollectionViewDelegate? {
        didSet {
            if let cardDelegate = delegate as? CardCollectionViewDelegate {
                cardDelegate.delegate = self
            }
        }
    }
    
    private var layout: StickyHeaderCollectionViewLayout?
    private var profile: ProfileService.Containers.Profile?
    private var collectionViewDataSource: ProfileOverlaidCollectionViewDataSource?
    private var collectionViewDelegate: StickyHeaderCollectionViewDelegate?
    
    convenience init(profile: ProfileService.Containers.Profile?, sections: [String]?) {
        let stickyLayout = StickyHeaderCollectionViewLayout()
        self.init(frame: CGRectZero, collectionViewLayout: stickyLayout)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        layout = stickyLayout
        layout?.headerHeight = ProfileHeaderCollectionReusableView.height
        // height of section indicator + height of navbar
        layout?.stickySectionHeight = 84.0
        collectionViewDataSource = ProfileOverlaidCollectionViewDataSource(
            profile: AuthViewController.getLoggedInUserProfile()!,
            sections: sections
        )
        collectionViewDataSource?.registerCardHeader(self)
        collectionViewDelegate = StickyHeaderCollectionViewDelegate()
        backgroundColor = UIColor.clearColor()
        dataSource = collectionViewDataSource
        delegate = collectionViewDelegate
        userInteractionEnabled = true
        
        // XXX we should consider making this a public function so the view controller can instantiate an activity indicator and then call load data, clearing activity indicator when the content has loaded
        collectionViewDataSource?.loadData { (error) -> Void in
            self.reloadData()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let profileHeaderView = collectionViewDataSource?.profileHeaderView {
            let contentOffset = scrollView.contentOffset
            let minOffsetToMakeChanges: CGFloat = 20.0
            
            // Do not change anything unless user scrolls up more than 20 points
            if contentOffset.y > minOffsetToMakeChanges {
                
                // Scale down the image and reduce opacity
                let profileImageFractionValue = 1.0 - (contentOffset.y - minOffsetToMakeChanges)/profileHeaderView.profileImage.frameY
                profileHeaderView.profileImage.alpha = profileImageFractionValue
                if profileImageFractionValue >= 0 {
                    var transform = CGAffineTransformMakeScale(profileImageFractionValue, profileImageFractionValue)
                    profileHeaderView.profileImage.transform = transform
                }
                
                // Reduce opacity of the name and title label at a faster pace
                let titleLabelAlpha = 1.0 - contentOffset.y/(profileHeaderView.titleLabel.frameY - 40.0)
                profileHeaderView.titleLabel.alpha = titleLabelAlpha
                profileHeaderView.nameLabel.alpha = 1.0 - contentOffset.y/(profileHeaderView.nameLabel.frameY - 40.0)
                profileHeaderView.nameNavLabel.alpha = titleLabelAlpha <= 0.0 ? profileHeaderView.nameNavLabel.alpha + 1/20 : 0.0
            }
            else {
                // Change alpha faster for profile image
                let profileImageAlpha = max(0.0, 1.0 - -contentOffset.y/80.0)
                
                // Change it slower for everything else
                let otherViewsAlpha = max(0.0, 1.0 - -contentOffset.y/120.0)
                profileHeaderView.nameLabel.alpha = otherViewsAlpha
                profileHeaderView.nameNavLabel.alpha = 0.0
                profileHeaderView.titleLabel.alpha = otherViewsAlpha
                profileHeaderView.profileImage.alpha = profileImageAlpha
                profileHeaderView.visualEffectView.alpha = otherViewsAlpha
                profileHeaderView.profileImage.transform = CGAffineTransformIdentity
            }
        }
    }

    // MARK: - Handle Touch Events
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        // Check if the touch happened in the header view
        // The header view internally overrides and ensures only touches on uicontrol
        // are asked to be captured.
        if let headerView = collectionViewDataSource?.profileHeaderView {
            let pointRelativeToHeaderView = headerView.convertPoint(point, fromView: self)
            if headerView.pointInside(pointRelativeToHeaderView, withEvent: event) {
                return headerView.tappedButtonInSegmentedControl
            }
        }

        // Pass touch events to other sub-views
        return nil
    }
}
