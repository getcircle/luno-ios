//
//  ChatRoom.swift
//  Circle
//
//  Created by Michael Hahn on 11/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

class ChatRoom: PFObject, PFSubclassing {
    
    var members: [Person]! {
        return objectForKey("members") as [Person]
    }
    
    var lastMessage: Message! {
        return objectForKey("lastMessage") as Message
    }
    
    override class func load() {
        registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "ChatRoom"
    }
    
    class func getRoomWithBlock(members: [Person], block: (ChatRoom, NSError?) -> Void) {
        let parseQuery = ChatRoom.query() as PFQuery
        parseQuery.whereKey("members", containsAllObjectsInArray: members)
        parseQuery.includeKey("members")
        parseQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            var chatRoom: ChatRoom?
            
            // find the room with an equal number of members. Parse doesn't support exact array lookups.
            for room in objects as [ChatRoom] {
                if room.members.count == members.count {
                    chatRoom = room
                    break
                }
            }
            if chatRoom == nil {
                chatRoom = ChatRoom()
                chatRoom!["members"] = members
                chatRoom!.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                    block(chatRoom!, error)
                }
            } else {
                block(chatRoom!, nil)
            }
        }
    }
    
    class func recordMessage(message: Message) {
        message.chatRoom.fetchIfNeededInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            let room = object as ChatRoom
            room["lastMessage"] = message
            room.saveInBackgroundWithBlock(nil)
        }
    }
    
    func description() -> String {
        var descriptions = [String]()
        let currentUser = AuthViewController.getLoggedInPerson()
        for person in members {
//            if person.objectId != currentUser?.objectId {
//                descriptions.append(person.description)
//            }
        }
        return ", ".join(descriptions)
    }
    
    func profileImageURL() -> String {
        var profileImageURLs = [String]()
        let currentUser = AuthViewController.getLoggedInPerson()
        for person in members {
//            if person.objectId != currentUser?.objectId {
//                profileImageURLs.append(person.profileImageURL)
//            }
        }
        // In the future we may want to show a collage of the various users in the chat room. For now, just grab the first.
        return profileImageURLs[0]
    }
    
}
