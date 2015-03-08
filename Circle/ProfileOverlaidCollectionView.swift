//
//  ProfileOverlaidCollectionView.swift
//  Circle
//
//  Created by Michael Hahn on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

struct ProfileDetailView {
    var title: String
    var image: String?
}

class ProfileOverlaidCollectionViewDataSource: CardDataSource {

    var profileHeaderView: ProfileHeaderCollectionReusableView?
    var profileHeaderViewDelegate: ProfileDetailSegmentedControlDelegate?
    private var profile: ProfileService.Containers.Profile?
    private var sections: [ProfileDetailView]?
    
    convenience init(profile withProfile: ProfileService.Containers.Profile, sections withSections: [ProfileDetailView]?) {
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
            
            profileHeaderView = supplementaryView
            profileHeaderView?.sections = sections
            if let delegate = profileHeaderViewDelegate {
                profileHeaderView?.profileSegmentedControlDelegate = delegate
            }
            return supplementaryView
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
    
    // MARK: - Public Methods
    
    func matchContentHeight(height: CGFloat) {
        resetCards()
        let cells = Int(ceil(height / CircleCollectionViewCell.height))
        let card = Card(cardType: .Empty, title: "Empty")
        var placeholders = [Int]()
        for i in 0..<cells {
            placeholders.append(i)
        }
        card.addContent(content: placeholders)
        appendCard(card)
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
    
    convenience init(profile: ProfileService.Containers.Profile?, sections: [ProfileDetailView]?) {
        let stickyLayout = StickyHeaderCollectionViewLayout()
        self.init(frame: CGRectZero, collectionViewLayout: stickyLayout)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        layout = stickyLayout
        layout?.headerHeight = ProfileHeaderCollectionReusableView.height
        // height of section indicator + status bar + navbar
        layout?.stickySectionHeight = 20.0 + 44.0
        collectionViewDataSource = ProfileOverlaidCollectionViewDataSource(
            profile: profile!,
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
            profileHeaderView.adjustViewForScrollContentOffset(scrollView.contentOffset)
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
                return headerView.tappedButton
            }
        }

        // Pass touch events to other sub-views
        return nil
    }
    
    // MARK: - Public Methods
    
    func matchContentHeight(height: CGFloat) {
        collectionViewDataSource?.matchContentHeight(height)
        reloadData()
    }
}
