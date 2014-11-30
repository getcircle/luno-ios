//
//  ConversationHistory.swift
//  Circle
//
//  Created by Michael Hahn on 11/30/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

class ConversationHistory: PFObject, PFSubclassing {
    
    var sender: Person! {
        return self.objectForKey("sender") as Person
    }
    
    var recipient: Person! {
        return self.objectForKey("recipient") as Person
    }
    
    var message: Message! {
        return self.objectForKey("message") as Message
    }
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "ConversationHistory"
    }
    
    // Parse doesn't support distinct or group by queries. ConversationHistory will be a record of the last message a sender has sent to a specific recipient. We can use this to populate the overall Messages view for an individual.
    class func recordMessage(message: Message) {
        let parseQuery = ConversationHistory.query() as PFQuery
        parseQuery.whereKey("sender", equalTo: AuthViewController.getLoggedInPerson())
        parseQuery.whereKey("recipient", equalTo: message.recipient)
        parseQuery.getFirstObjectInBackgroundWithBlock({ (object: PFObject!, error: NSError!) -> Void in
            var history: ConversationHistory
            if object != nil {
                history = object as ConversationHistory
            } else {
                history = ConversationHistory()
                history["sender"] = AuthViewController.getLoggedInPerson()
                history["recipient"] = message.recipient
            }
            history["message"] = message
            history.saveInBackgroundWithBlock(nil)
        })
    }
    
}
