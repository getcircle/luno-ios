//
//  Message.swift
//  Circle
//
//  Created by Michael Hahn on 11/26/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

class Message: PFObject, PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Message"
    }
    
    var contents: String! {
        return self.objectForKey("contents") as String!
    }
    
    
    var date: NSDate! {
        return self.objectForKey("date") as NSDate!
    }
    
    var ephemeral: Bool! {
        return self.objectForKey("ephemeral") as Bool!
    }
    
    var sender: Person! {
        return self.objectForKey("sender") as Person!
    }
    
    var readReceipts: [ReadReceipt]! {
        return self.objectForKey("readReceipts") as [ReadReceipt]!
    }
    
    var chatRoom: ChatRoom! {
        return self.objectForKey("chatRoom") as ChatRoom!
    }
    
    func currentUserHasRead() -> Bool {
        var hasRead = false
        if readReceipts != nil {
            for receipt in readReceipts {
                if receipt.person.objectId == AuthViewController.getLoggedInPerson()?.objectId {
                    hasRead = true
                    break
                }
            }
        }
        return hasRead
    }
    
    func markAsRead() -> Bool {
        let currentUser = AuthViewController.getLoggedInPerson()
        let hasRead = currentUserHasRead()
        var receipts = readReceipts ?? [ReadReceipt]()
        if !hasRead {
            let readReceipt = ReadReceipt()
            readReceipt["person"] = AuthViewController.getLoggedInPerson()?
            readReceipt["message"] = self
            receipts.append(readReceipt)
            
            self["readReceipts"] = receipts
        }
        return hasRead
    }
   
}
