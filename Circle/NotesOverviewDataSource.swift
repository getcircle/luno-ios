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
    
    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        let cardType = ofType != nil ? ofType : .Notes
        let notesCard = Card(cardType: cardType!, title: "")
        notesCard.addContent(content: content)
        notesCard.sectionInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        appendCard(notesCard)
    }
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        completionHandler(error: nil)
    }
}
