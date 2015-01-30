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
    
    // MARK: - Set Initial Data
    
    override func setInitialData(#content: [AnyObject], ofType: Card.CardType? = .People, withMetaData metaData:[AnyObject]? = nil) {
        let cardType = ofType != nil ? ofType : .Notes
        let notesCard = Card(cardType: cardType!, title: "")
        notes = content as Array<NoteService.Containers.Note>
        notesCard.addContent(content: notes)
        notesCard.metaData = metaData
        notesCard.sectionInset = UIEdgeInsetsMake(20.0, 0.0, 30.0, 0.0)
        appendCard(notesCard)
    }
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        completionHandler(error: nil)
    }
    
    func addNote(note: NoteService.Containers.Note) {
        notes.insert(note, atIndex: 0)
    }
    
    func removeNote(note: NoteService.Containers.Note) {
        notes = notes.filter { $0.id != note.id }
    }
}
