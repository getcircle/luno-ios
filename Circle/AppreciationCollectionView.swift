//
//  AppreciationCollectionView.swift
//  Circle
//
//  Created by Ravi Rani on 2/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class AppreciationCollectionView: UnderlyingCollectionView {

    private var layout: StickyHeaderCollectionViewLayout?
    private var profile: Services.Profile.Containers.ProfileV1?
    private var appreciationDataSource: AppreciationDataSource?
    private var appreciationDelegate: CardCollectionViewDelegate?
    
    convenience init(profile: Services.Profile.Containers.ProfileV1?) {
        let stickyLayout = StickyHeaderCollectionViewLayout()
        self.init(frame: CGRectZero, collectionViewLayout: stickyLayout)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        layout = stickyLayout
        layout?.headerHeight = ProfileHeaderCollectionReusableView.height
        appreciationDataSource = AppreciationDataSource(profile: profile!)
        appreciationDelegate = CardCollectionViewDelegate()
        backgroundColor = UIColor.appViewBackgroundColor()
        dataSource = appreciationDataSource
        delegate = appreciationDelegate
        alwaysBounceVertical = true
        
        let activityIndicatorView = addActivityIndicator()
        appreciationDataSource?.loadData { (error) -> Void in
            activityIndicatorView.stopAnimating()
            self.reloadData()
        }
    }
}

struct AppreciationNotifications {
    static let onAppreciationsChanged = "com.rhlabs.notification:onAppreciationsChanged"
}

class AppreciationDataSource: UnderlyingCollectionViewDataSource {
    
    var profile: Services.Profile.Containers.ProfileV1!
    private(set) var appreciations = Array<Services.Appreciation.Containers.AppreciationV1>()
    
    convenience init(profile withProfile: Services.Profile.Containers.ProfileV1) {
        self.init()
        profile = withProfile
    }

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Add placeholder card to load profile header instantly
        addPlaceholderCard()
        AppreciationService.Actions.getAppreciation(profile.id, completionHandler: { (appreciation, error) -> Void in
            if let appreciation = appreciation {
                self.appreciations = appreciation
                NSNotificationCenter.defaultCenter().postNotificationName(
                    AppreciationNotifications.onAppreciationsChanged,
                    object: nil,
                    userInfo: nil
                )
            }
            self.populateData()
            completionHandler(error: error)
        })
    }

    private func populateData() {
        // resetCards()
        
        // Add add note card
        let appreciateCard = Card(
            cardType: .Appreciate,
            title: AppStrings.AppreciateCTATitle,
            content: ["placeholder"],
            contentCount: 1,
            addDefaultFooter: false
        )
        appreciateCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        appendCard(appreciateCard)
        
        if appreciations.count > 0 {
            
            // Add appreciations card
            let card = Card(cardType: .Appreciations, title: AppStrings.AppreciateCTATitle)
            card.addContent(content: appreciations as [AnyObject])
            card.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
            appendCard(card)
        }
    }
    
    func addAppreciation(appreciation: Services.Appreciation.Containers.AppreciationV1) {
        appreciations.insert(appreciation, atIndex: 0)
        populateData()
    }
    
    func removeAppreciation(appreciation: Services.Appreciation.Containers.AppreciationV1) {
        appreciations = appreciations.filter { $0.id != appreciation.id }
        populateData()
    }
}
