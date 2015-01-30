//
//  NotesOverviewDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class NotesOverviewDataSource: CardDataSource {
    
    private(set) var notes = Array<NoteService.Containers.Note>()
    private var profiles = Array<ProfileService.Containers.Profile>()
    
    // MARK: - Set Initial Data
    
    override func setInitialData(#content: [AnyObject], ofType: Card.CardType? = .People, withMetaData metaData:[AnyObject]? = nil) {
        notes = content as Array<NoteService.Containers.Note>
        profiles = metaData as Array<ProfileService.Containers.Profile>
    }
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()

        let notesCard = Card(cardType: .Notes, title: "Notes")
        notesCard.addContent(content: notes)
        notesCard.metaData = profiles
        notesCard.sectionInset = UIEdgeInsetsMake(20.0, 0.0, 30.0, 0.0)
        appendCard(notesCard)
        completionHandler(error: nil)
    }
    
    func addNote(note: NoteService.Containers.Note, forProfile profile: ProfileService.Containers.Profile) {
        notes.insert(note, atIndex: 0)
        profiles.insert(profile, atIndex: 0)
    }
    
    func removeNote(note: NoteService.Containers.Note, forProfile profile: ProfileService.Containers.Profile) {
        for (index, note) in enumerate(notes) {
            if note.id == notes[index].id {
                notes.removeAtIndex(index)
                profiles.removeAtIndex(index)
                break
            }
        }
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is NotesCollectionViewCell {
            (cell as NotesCollectionViewCell).setProfile(profiles[indexPath.row])
        }
    }
}
