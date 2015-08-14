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
    
    struct ValidTimes {
        static let GoogleGroupsIntegrationValidTime = (2 * 60 * 60)
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
        var keys = NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys
        for key in keys {
            if let keyString = key as? String where keyString.hasPrefix("cache_") {
                removeObjectForKey(keyString)
            }
            
        }
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
        var uniqueProfileIDs = NSMutableOrderedSet(array: existingProfilesIDs)
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
    
    static func getRecordedSearchResults(limit: Int) -> [AnyObject] {
        var searchResults = [AnyObject]()
        let recordedResults = Realm().objects(RecentSearchResult).sorted("updated", ascending: false)
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
        
        return searchResults
    }
    
    static func setIntegrationSetting(value: Bool, ofType type: Services.Organization.Containers.Integration.IntegrationTypeV1) {
        CircleCache.sharedInstance.setObject(
            value,
            forKey: NSString(format: CircleCache.Keys.Integration, type.rawValue) as String,
            forTimeInSeconds: CircleCache.ValidTimes.GoogleGroupsIntegrationValidTime
        )
    }
    
    static func getIntegrationSetting(type: Services.Organization.Containers.Integration.IntegrationTypeV1) -> Bool? {
        if let value = CircleCache.sharedInstance.objectForKey(
            NSString(format: CircleCache.Keys.Integration, type.rawValue) as String
        ) as? Bool {
            return value
        }
        
        return nil
    }
}
