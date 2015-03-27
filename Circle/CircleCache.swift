//
//  CircleCache.swift
//  Circle
//
//  Created by Ravi Rani on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

/**
    CircleCache is a simple key, value disk cache. It can be used to store app level settings
    and other client specific data.

    It internally uses NSUserDefaults at this time but the underlying implementation is abstracted
    such that it can be updated without impact on the application code.
*/
class CircleCache {
    
    struct Keys {
        static var RecentProfileVisits = "recent_profile_visits"
    }
    
    /**
        A shared instance of `CircleCache`.
    */
    class var sharedInstance: CircleCache {
        struct Singleton {
            static let instance = CircleCache()
        }

        return Singleton.instance
    }

    func setObject(object: AnyObject, forKey key: String) {
        _setObject(object, forKey: key)
    }
    
    func objectForKey(key: String) -> AnyObject? {
        return _objectForKey(key)
    }
    
    func removeObjectForKey(key: String) {
        _removeObjectForKey(key)
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
    
    class func recordProfileVisit(profile: ProfileService.Containers.Profile) {
        var existingProfilesIDs = CircleCache.sharedInstance.objectForKey(CircleCache.Keys.RecentProfileVisits) as [String]? ?? [String]()
        var uniqueProfileIDs = NSMutableOrderedSet(array: existingProfilesIDs)
        uniqueProfileIDs.insertObject(profile.id, atIndex: 0)
        let maxRecords: Int = min(uniqueProfileIDs.count, 5)
        existingProfilesIDs = uniqueProfileIDs.array as [String]
        existingProfilesIDs = Array(existingProfilesIDs[0..<maxRecords])
        CircleCache.sharedInstance.setObject(existingProfilesIDs, forKey: CircleCache.Keys.RecentProfileVisits)
    }
}
