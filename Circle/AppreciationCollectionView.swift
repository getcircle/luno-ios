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
    private var profile: ProfileService.Containers.Profile?
    private var appreciationDataSource: AppreciationDataSource?
    private var appreciationDelegate: StickyHeaderCollectionViewDelegate?
    
    convenience init(profile: ProfileService.Containers.Profile?) {
        let stickyLayout = StickyHeaderCollectionViewLayout()
        self.init(frame: CGRectZero, collectionViewLayout: stickyLayout)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        layout = stickyLayout
        layout?.headerHeight = ProfileHeaderCollectionReusableView.height
        appreciationDataSource = AppreciationDataSource(profile: profile!)
        appreciationDataSource?.registerCardHeader(self)
        appreciationDelegate = StickyHeaderCollectionViewDelegate()
        backgroundColor = UIColor.viewBackgroundColor()
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
    static let onAppreciationsChanged = "com.ravcode.notification:onAppreciationsChanged"
}

class AppreciationDataSource: UnderlyingCollectionViewDataSource {
    
    var profile: ProfileService.Containers.Profile!
    private(set) var appreciations = Array<AppreciationService.Containers.Appreciation>()
    
    convenience init(profile withProfile: ProfileService.Containers.Profile) {
        self.init()
        profile = withProfile
    }

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Add placeholder card to load profile header instantly
        var placeholderCard = Card(cardType: .Placeholder, title: "Info")
        appendCard(placeholderCard)
        
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
        resetCards()
        
        // Add add note card
//        let addNotesCard = Card(
//            cardType: .AddNote,
//            title: "Add Note",
//            content: ["placeholder"],
//            contentCount: 1,
//            addDefaultFooter: false
//        )
//        addNotesCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
//        appendCard(addNotesCard)
        
        if appreciations.count > 0 {
            // Add appreciations card
            let card = Card(cardType: .Appreciations, title: "Appreciations")
            card.addContent(content: appreciations as [AnyObject])
            card.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
            appendCard(card)
        }
    }
    
//    func addNote(note: NoteService.Containers.Note) {
//        notes.insert(note, atIndex: 0)
//        populateData()
//    }
//    
//    func removeNote(note: NoteService.Containers.Note) {
//        notes = notes.filter { $0.id != note.id }
//        populateData()
//    }
}
