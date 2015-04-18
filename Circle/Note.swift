//
//  Note.swift
//  Circle
//
//  Created by Michael Hahn on 1/19/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias CreateNoteCompletionHandler = (note: Services.Note.Containers.NoteV1?, error: NSError?) -> Void
typealias DeleteNoteCompletionHandler = (error: NSError?) -> Void
typealias UpdateNoteCompletionHandler = (note: Services.Note.Containers.NoteV1?, error: NSError?) -> Void
typealias GetNotesCompletionHandler = (notes: Array<Services.Note.Containers.NoteV1>?, error: NSError?) -> Void

extension Services.Note.Actions {

    class func createNote(note: Services.Note.Containers.NoteV1, completionHandler: CreateNoteCompletionHandler?) {
        let requestBuilder = Services.Note.Actions.CreateNote.RequestV1.builder()
        requestBuilder.note = note
        let client = ServiceClient(serviceName: "note")
        client.callAction(
            "create_note",
            extensionField: Services.Registry.Requests.Note.createNote(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Note.createNote()
            ) as? Services.Note.Actions.CreateNote.ResponseV1
            completionHandler?(note: response?.note, error: error)
        }
    }

    class func deleteNote(note: Services.Note.Containers.NoteV1, completionHandler: DeleteNoteCompletionHandler?) {
        let requestBuilder = Services.Note.Actions.DeleteNote.RequestV1.builder()
        requestBuilder.note = note
        let client = ServiceClient(serviceName: "note")
        client.callAction(
            "delete_note",
            extensionField: Services.Registry.Requests.Note.deleteNote(),
            requestBuilder: requestBuilder
        ) { (_, _, _, error) -> Void in
            completionHandler?(error: error)
            return
        }
    }

    class func updateNote(note: Services.Note.Containers.NoteV1, completionHandler: UpdateNoteCompletionHandler?) {
        let requestBuilder = Services.Note.Actions.UpdateNote.RequestV1.builder()
        requestBuilder.note = note
        let client = ServiceClient(serviceName: "note")
        client.callAction(
            "update_note",
            extensionField: Services.Registry.Requests.Note.updateNote(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Note.updateNote()
            ) as? Services.Note.Actions.UpdateNote.ResponseV1
            completionHandler?(note: response?.note, error: error)
        }
    }

    class func getNotes(forProfileId: String, completionHandler: GetNotesCompletionHandler?) {
        let requestBuilder = Services.Note.Actions.GetNotes.RequestV1.builder()
        requestBuilder.for_profileId = forProfileId
        requestBuilder.owner_profileId = AuthViewController.getLoggedInUserProfile()!.id
        let client = ServiceClient(serviceName: "note")
        client.callAction(
            "get_notes",
            extensionField: Services.Registry.Requests.Note.getNotes(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Note.getNotes()
            ) as? Services.Note.Actions.GetNotes.ResponseV1
            completionHandler?(notes: response?.notes, error: error)
        }
    }

}
