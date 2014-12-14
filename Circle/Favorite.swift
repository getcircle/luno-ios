//
//  Favorite.swift
//  Circle
//
//  Created by Ravi Rani on 12/8/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

struct FavoritesHolder {
    static var favorites: NSSet?
}

class Favorite: PFObject, PFSubclassing {
    
    var person: Person! {
        return objectForKey("person") as Person!
    }
    
    var ofPersonObjectId: String! {
        return objectForKey("ofPersonObjectId") as String!
    }
    
    override class func load() {
        registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Favorite"
    }
    
    class func fetchAndCacheFavorites() {
        let parseQuery = Favorite.query() as PFQuery
        parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
        parseQuery.includeKey("person")
        parseQuery.orderByAscending("createdAt")
        // Ideally we will use exact match in the query but Parse is weird.
// TODO: Change querying when switching to our backend
        parseQuery.whereKey("ofPersonObjectId", containsString: PFUser.currentUser().objectId)
        parseQuery.findObjectsInBackgroundWithBlock { (favorites, error: NSError!) -> Void in
            if error == nil {
                var favoritePeople = NSMutableSet(capacity: favorites.count)
                for favorite in favorites as [Favorite] {
                    favoritePeople.addObject(favorite.person)
                }
                
                FavoritesHolder.favorites = favoritePeople
            }
        }
    }
    
    class func isFavoritePerson(person: Person) -> Bool {
        var isFavorite = false
        // Ideally we will just use contains object but Parse objects are weird.
// TODO: change implementation when switching to our backend
        for favorite in FavoritesHolder.favorites?.allObjects as [Person] {
            if favorite.objectId == person.objectId {
                isFavorite = true
                break
            }
        }
        return isFavorite
    }
    
    class func getFavorites() -> [Person]? {
        return (FavoritesHolder.favorites?.allObjects as [Person])
    }
    
    class func markFavorite(person: Person) {
        if Favorite.isFavoritePerson(person) == false {
            var favorite = Favorite()
            favorite.setObject(person, forKey: "person")
            favorite.setObject(PFUser.currentUser().objectId, forKey: "ofPersonObjectId")
            favorite.saveInBackgroundWithBlock({ (saved, error: NSError!) -> Void in
                if error != nil {
                    // Update cache if there was an error
                }
            })
            
            // Assume save is going to be successful
            var favorites = NSMutableSet(set: FavoritesHolder.favorites!)
            favorites.addObject(person)
            FavoritesHolder.favorites = favorites
        }
    }
    
    class func removeFavorite(person: Person) {
        if Favorite.isFavoritePerson(person) != false {
            let parseQuery = Favorite.query() as PFQuery
            parseQuery.whereKey("person", equalTo: person)
            parseQuery.whereKey("ofPersonObjectId", containsString: PFUser.currentUser().objectId)
            parseQuery.findObjectsInBackgroundWithBlock { (favorites, error: NSError!) -> Void in
                for favorite in favorites as [Favorite] {
                    favorite.deleteInBackgroundWithBlock({ (deleted, error: NSError!) -> Void in
                        if error != nil {
                            // Update cache if there was an error
                        }
                    })
                }
            }
            
            // Assume delete is going to be successful
            var favorites = NSMutableSet(set: FavoritesHolder.favorites!)
            favorites.removeObject(person)
            FavoritesHolder.favorites = favorites
        }
    }
}
