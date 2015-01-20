//
//  NoteService.swift
//  Circle
//
//  Created by Michael Hahn on 1/19/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias CreateNoteCompletionHandler = (note: NoteService.Containers.Note?, error: NSError?) -> Void
typealias DeleteNoteCompletionHandler = (error: NSError?) -> Void
typealias UpdateNoteCompletionHandler = (note: NoteService.Containers.Note?, error: NSError?) -> Void

extension NoteService {
    class Actions {
        
        class func createNote(note: NoteService.Containers.Note, completionHandler: CreateNoteCompletionHandler?) {
            let requestBuilder = NoteService.CreateNote.Request.builder()
            requestBuilder.note = note
            let client = ServiceClient(serviceName: "note")
            client.callAction(
                "create_note",
                extensionField: NoteServiceRequests_create_note,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    NoteServiceRequests_create_note
                ) as? NoteService.CreateNote.Response
                completionHandler?(note: response?.note, error: error)
            }
        }
        
        class func deleteNote(note: NoteService.Containers.Note, completionHandler: DeleteNoteCompletionHandler?) {
            println("TODO delete the note")
            completionHandler?(error: nil)
        }
        
        class func updateNote(note: NoteService.Containers.Note, completionHandler: UpdateNoteCompletionHandler?) {
            println("TODO update the note")
            completionHandler?(note: note, error: nil)
        }
        
    }
}
