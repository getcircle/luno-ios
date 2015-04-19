//
//  ProfileNotesCollectionView.swift
//  Circle
//
//  Created by Michael Hahn on 1/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

private let NoteCellReuseIdentifier = "NotesCellReuseIdentifier"

struct ProfileNotesNotifications {
    static let onNotesChanged = "com.rhlabs.notification:onNotesChanged"
}

// TODO should potentially just take notes as an init variable so we can use the getExtendedProfile call
class ProfileNotesDataSource: UnderlyingCollectionViewDataSource {
    
    var profile: Services.Profile.Containers.ProfileV1!
    private(set) var notes = Array<Services.Note.Containers.NoteV1>()
    
    convenience init(profile withProfile: Services.Profile.Containers.ProfileV1) {
        self.init()
        profile = withProfile
    }

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Add placeholder card to load profile header instantly
        addPlaceholderCard()
        Services.Note.Actions.getNotes(profile.id) { (notes, error) -> Void in
            if let notes = notes {
                self.notes = notes
                NSNotificationCenter.defaultCenter().postNotificationName(
                    ProfileNotesNotifications.onNotesChanged,
                    object: nil,
                    userInfo: nil
                )
            }
            self.populateData()
            completionHandler(error: error)
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is NotesCollectionViewCell {
            (cell as! NotesCollectionViewCell).showUserProfile = false
        }
    }

    private func populateData() {
        resetCards()

        addPlaceholderCard()
        // Add add note card
        let addNotesCard = Card(
            cardType: .AddNote,
            title: "Add Note",
            content: ["placeholder"],
            contentCount: 1,
            addDefaultFooter: false
        )
        addNotesCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)
        appendCard(addNotesCard)
        
        if notes.count > 0 {
            // Add notes card
            let card = Card(cardType: .Notes, title: "Notes")
            card.addContent(content: notes as [AnyObject])
            card.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
            appendCard(card)
        }
    }
    
    func addNote(note: Services.Note.Containers.NoteV1) {
        notes.insert(note, atIndex: 0)
        populateData()
    }
    
    func removeNote(note: Services.Note.Containers.NoteV1) {
        notes = notes.filter { $0.id != note.id }
        populateData()
    }
}

class ProfileNotesCollectionView: UnderlyingCollectionView {
    
    private var layout: StickyHeaderCollectionViewLayout?
    private var profile: Services.Profile.Containers.ProfileV1?
    private var profileNotesDataSource: ProfileNotesDataSource?
    private var profileNotesDelegate: CardCollectionViewDelegate?
    
    convenience init(profile: Services.Profile.Containers.ProfileV1?) {
        let stickyLayout = StickyHeaderCollectionViewLayout()
        self.init(frame: CGRectZero, collectionViewLayout: stickyLayout)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        layout = stickyLayout
        layout?.headerHeight = ProfileHeaderCollectionReusableView.height
        profileNotesDataSource = ProfileNotesDataSource(profile: profile!)
        profileNotesDelegate = CardCollectionViewDelegate()
        backgroundColor = UIColor.appViewBackgroundColor()
        dataSource = profileNotesDataSource
        delegate = profileNotesDelegate
        alwaysBounceVertical = true
        
        let activityIndicatorView = addActivityIndicator()
        profileNotesDataSource?.loadData { (error) -> Void in
            activityIndicatorView.stopAnimating()
            self.reloadData()
        }
    }
}
