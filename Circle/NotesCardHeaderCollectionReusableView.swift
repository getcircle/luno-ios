//
//  NotesCardHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Michael Hahn on 1/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

struct NotesCardHeaderCollectionReusableViewNotifications {
    static let onAddNoteNotification = "com.rhlabs.notification:onAddNoteNotification"
}

class NotesCardHeaderCollectionReusableView: CircleCollectionReusableView {
    
    override class var classReuseIdentifier: String {
        return "NotesCardHeaderCollectionReusableView"
    }

    @IBAction func handleAddNote(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            NotesCardHeaderCollectionReusableViewNotifications.onAddNoteNotification,
            object: nil
        )
    }
    
}
