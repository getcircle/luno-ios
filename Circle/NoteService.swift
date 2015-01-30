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
typealias GetNotesCompletionHandler = (notes: Array<NoteService.Containers.Note>?, error: NSError?) -> Void

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
            let requestBuilder = NoteService.DeleteNote.Request.builder()
            requestBuilder.note = note
            let client = ServiceClient(serviceName: "note")
            client.callAction(
                "delete_note",
                extensionField: NoteServiceRequests_delete_note,
                requestBuilder: requestBuilder) { (_, _, _, actionResponse, error) -> Void in
                    completionHandler?(error: error)
                    return
            }
        }
        
        class func updateNote(note: NoteService.Containers.Note, completionHandler: UpdateNoteCompletionHandler?) {
            let requestBuilder = NoteService.UpdateNote.Request.builder()
            requestBuilder.note = note
            let client = ServiceClient(serviceName: "note")
            client.callAction(
                "update_note",
                extensionField: NoteServiceRequests_update_note,
                requestBuilder: requestBuilder) { (_, _, _, actionResponse, error) -> Void in
                    let response = actionResponse?.result.getExtension(
                        NoteServiceRequests_update_note
                    ) as? NoteService.UpdateNote.Response
                    completionHandler?(note: response?.note, error: error)
            }
        }
        
        class func getNotes(forProfileId: String, completionHandler: GetNotesCompletionHandler?) {
            let requestBuilder = NoteService.GetNotes.Request.builder()
            requestBuilder.for_profile_id = forProfileId
            requestBuilder.owner_profile_id = AuthViewController.getLoggedInUserProfile()!.id
            let client = ServiceClient(serviceName: "note")
            client.callAction(
                "get_notes",
                extensionField: NoteServiceRequests_get_notes,
                requestBuilder: requestBuilder) { (_, _, _, actionResponse, error) -> Void in
                    let response = actionResponse?.result.getExtension(
                        NoteServiceRequests_get_notes
                    ) as? NoteService.GetNotes.Response
                    completionHandler?(notes: response?.notes, error: error)
            }
        }
        
    }
}
