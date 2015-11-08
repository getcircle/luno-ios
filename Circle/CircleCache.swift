//
//  CircleCache.swift
//  Circle
//
//  Created by Ravi Rani on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry
import RealmSwift

/**
    CircleCache is a simple key, value disk cache. It can be used to store app level settings
    and other client specific data.

    It internally uses NSUserDefaults at this time but the underlying implementation is abstracted
    such that it can be updated without impact on the application code.
*/
class CircleCache {
    
    struct Keys {
        static let RecentProfileVisits = "cache_recent_profile_visits"
        static let Integration = "cache_org_integration_%d"
        private static let KeyValidationTimers = "cache_key_validation_timers"
    }

    // Key Name - (Time of entry, number of seconds valid)
    private var timeForKeys = [String: AnyObject]()
    
    /**
        A shared instance of `CircleCache`.
    */
    class var sharedInstance: CircleCache {
        struct Singleton {
            static let instance = CircleCache()
        }

        return Singleton.instance
    }

    func setObject(object: AnyObject, forKey key: String, forTimeInSeconds timeInSeconds: Int) {
        setObject(object, forKey: key)
        _setValidationTimer(timeInSeconds, forKey: key)
    }
    
    func setObject(object: AnyObject, forKey key: String) {
        _setObject(object, forKey: key)
    }
    
    func objectForKey(key: String) -> AnyObject? {
        if let object: AnyObject = _objectForKey(key) {
            if _isKeyValueValid(key) {
                return object
            }
        }
        
        return nil
    }
    
    func removeObjectForKey(key: String) {
        _removeObjectForKey(key)
    }
    
    func clearCache() {
        let keys = NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys
        for key in keys {
            if key.hasPrefix("cache_") {
                removeObjectForKey(key)
            }
        }
        
        // Remove entries from the persistent store
        // ASSUMPTION: We will be only using it as a cache for now
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.deleteAll()
                }
            }
            catch {
                print("Error: \(error)")
            }
        })
    }
    
    private func _setValidationTimer(timeInSeconds: Int, forKey key: String) {
        var validationTimerForKeys = [String: AnyObject]()
        if let timeForKeys = objectForKey(CircleCache.Keys.KeyValidationTimers) as? Dictionary<String, AnyObject> {
            validationTimerForKeys = timeForKeys
        }
        
        validationTimerForKeys[key] = ["time_of_entry": NSDate().timeIntervalSince1970, "expires_in_time": timeInSeconds]
        setObject(validationTimerForKeys, forKey: CircleCache.Keys.KeyValidationTimers)
    }
    
    private func _isKeyValueValid(key: String) -> Bool {
        if let timeForKeys = _objectForKey(CircleCache.Keys.KeyValidationTimers) as? Dictionary<String, AnyObject>, timeValues: AnyObject = timeForKeys[key] {
            if Int((timeValues["time_of_entry"] as! NSTimeInterval) - NSDate().timeIntervalSince1970) > (timeValues["expires_in_time"] as! Int) {
                return false
            }
        }
        
        return true
    }
    
    private func _setObject(object: AnyObject, forKey key: String) {
        NSUserDefaults.standardUserDefaults().setObject(object, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func _objectForKey(key: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }

    private func _removeObjectForKey(key: String) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

extension CircleCache {
    
    static func recordProfileVisit(profile: Services.Profile.Containers.ProfileV1) {
        var existingProfilesIDs = CircleCache.sharedInstance.objectForKey(CircleCache.Keys.RecentProfileVisits) as! [String]? ?? [String]()
        let uniqueProfileIDs = NSMutableOrderedSet(array: existingProfilesIDs)
        uniqueProfileIDs.insertObject(profile.id, atIndex: 0)
        let maxRecords: Int = min(uniqueProfileIDs.count, 5)
        existingProfilesIDs = uniqueProfileIDs.array as! [String]
        existingProfilesIDs = Array(existingProfilesIDs[0..<maxRecords])
        CircleCache.sharedInstance.setObject(existingProfilesIDs, forKey: CircleCache.Keys.RecentProfileVisits)
    }
    
    static func recordProfileSearchResult(profile: Services.Profile.Containers.ProfileV1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let recentSearchResult = RecentSearchResult()
            recentSearchResult.id = profile.id
            recentSearchResult.object = profile.data()
            recentSearchResult.type = RecentSearchResult.ResultType.Profile.rawValue
            RecentSearchResult.createOrUpdate(recentSearchResult)
        })
    }
    
    static func updateCachedDataInRecordedSearchResultsForProfile(profile: Services.Profile.Containers.ProfileV1) {
        do {
            let recordedSearchResultsForProfile = try Realm().objects(RecentSearchResult).filter("id = %@ AND type = %d", profile.id, RecentSearchResult.ResultType.Profile.rawValue)
            for searchResult in recordedSearchResultsForProfile {
                try Realm().write({ () -> Void in
                    searchResult.object = profile.data()
                })
            }
        }
        catch {
            print("Error: \(error)")
        }
    }

    static func recordTeamSearchResult(team: Services.Organization.Containers.TeamV1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let recentSearchResult = RecentSearchResult()
            recentSearchResult.id = team.id
            recentSearchResult.object = team.data()
            recentSearchResult.type = RecentSearchResult.ResultType.Team.rawValue
            RecentSearchResult.createOrUpdate(recentSearchResult)
        })
    }

    static func recordLocationSearchResult(location: Services.Organization.Containers.LocationV1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let recentSearchResult = RecentSearchResult()
            recentSearchResult.id = location.id
            recentSearchResult.object = location.data()
            recentSearchResult.type = RecentSearchResult.ResultType.Location.rawValue
            RecentSearchResult.createOrUpdate(recentSearchResult)
        })
    }
    
    static func recordProfileStatusSearchResult(profileStatus: Services.Profile.Containers.ProfileStatusV1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let recentSearchResult = RecentSearchResult()
            recentSearchResult.id = profileStatus.id
            recentSearchResult.object = profileStatus.data()
            recentSearchResult.type = RecentSearchResult.ResultType.ProfileStatus.rawValue
            RecentSearchResult.createOrUpdate(recentSearchResult)
        })
    }
    
    static func recordPostSearchResult(post: Services.Post.Containers.PostV1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let recentSearchResult = RecentSearchResult()
            recentSearchResult.id = post.id
            recentSearchResult.object = post.data()
            recentSearchResult.type = RecentSearchResult.ResultType.Post.rawValue
            RecentSearchResult.createOrUpdate(recentSearchResult)
        })
    }
    
    static func getRecordedSearchResults(limit: Int) -> [AnyObject] {
        var searchResults = [AnyObject]()
        
        do {
            let recordedResults = try Realm().objects(RecentSearchResult).sorted("updated", ascending: false)
            var counter: Int = 0
            for result in recordedResults {
                if counter >= limit {
                    break
                }
                
                if let resultObject: AnyObject = RecentSearchResult.getObjectFromResult(result) {
                    searchResults.append(resultObject)
                    counter++
                }
            }
        }
        catch {
            print("Error: \(error)")
        }
        
        return searchResults
    }
}
