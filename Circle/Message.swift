//
//  Message.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

class Message: PFObject, PFSubclassing {
    
    override class func load() {
        registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Message"
    }
    
    var contents: String! {
        return objectForKey("contents") as String!
    }
    
    
    var date: NSDate! {
        return objectForKey("date") as NSDate!
    }
    
    var ephemeral: Bool! {
        return objectForKey("ephemeral") as Bool!
    }
    
    var sender: Person! {
        return objectForKey("sender") as Person!
    }
    
    var readReceipts: [ReadReceipt]! {
        return objectForKey("readReceipts") as [ReadReceipt]!
    }
    
    var chatRoom: ChatRoom! {
        return objectForKey("chatRoom") as ChatRoom!
    }
    
    func hasBeenReadByAll() -> Bool {
        // hack: we don't store a read receipt for the sender, so any read receipt means that the other user has read it, given 1-1 chat.
        return readReceipts != nil && readReceipts.count > 0
    }
    
    func currentUserHasRead() -> Bool {
        let currentUser = AuthViewController.getLoggedInPerson()
        var hasRead = false
        if readReceipts != nil {
            // HACK: since we know that we only have 1-1 chat right now and we don't add a read receipt for the sender, if this isn't the sender and we have any readReceipts, then the user had read it.
            if sender.objectId != currentUser?.objectId && readReceipts.count > 0 {
                hasRead = true
            }
        }
        return hasRead
    }
    
    func markAsRead() -> Bool {
        let currentUser = AuthViewController.getLoggedInPerson()
        let hasRead = currentUserHasRead()
        var receipts = readReceipts ?? [ReadReceipt]()
        if !hasRead && sender.objectId != currentUser?.objectId {
            let readReceipt = ReadReceipt()
            readReceipt["person"] = AuthViewController.getLoggedInPerson()?
            readReceipt["message"] = self
            receipts.append(readReceipt)
            
            self["readReceipts"] = receipts
        }
        return hasRead
    }
   
}
