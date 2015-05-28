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
        static let RecentProfileVisits = "recent_profile_visits"
        static let DynamicOrgIntegration = "org_integration_%d"
        private static let KeyValidationTimers = "key_validation_timers"
    }
    
    struct ValidTimes {
        static let GoogleGroupsIntegrationValidTime = (2 * 60 * 60)
    }
    
    // Key Name - (Time of entry, number of seconds valid)
    private var timeForKeys = [String: (NSTimeInterval, Int)]()
    
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
    
    private func _setValidationTimer(timeInSeconds: Int, forKey key: String) {
        var validationTimerForKeys = [String: (NSTimeInterval, Int)]()
        if let timeForKeys = objectForKey(CircleCache.Keys.KeyValidationTimers) as? Dictionary<String, (NSTimeInterval, Int)> {
            validationTimerForKeys = timeForKeys
        }
        
        validationTimerForKeys[key] = (NSDate().timeIntervalSince1970, timeInSeconds)
        setObject(validationTimerForKeys as! AnyObject, forKey: CircleCache.Keys.KeyValidationTimers)
    }
    
    private func _isKeyValueValid(key: String) -> Bool {
        if let timeForKeys = objectForKey(CircleCache.Keys.KeyValidationTimers) as? Dictionary<String, (NSTimeInterval, Int)>,
            timeValues = timeForKeys[key] {
            if Int (timeValues.0 - NSDate().timeIntervalSince1970) > timeValues.1 {
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
    
    static func setIntegrationSetting(value: Bool, ofType type: Services.Organization.Containers.Integration.IntegrationTypeV1) {
        CircleCache.sharedInstance.setObject(
            value,
            forKey: NSString(format: CircleCache.Keys.DynamicOrgIntegration, type.rawValue) as String,
            forTimeInSeconds: CircleCache.ValidTimes.GoogleGroupsIntegrationValidTime
        )
    }
    
    static func getIntegrationSetting(type: Services.Organization.Containers.Integration.IntegrationTypeV1) -> Bool? {
        if let value = CircleCache.sharedInstance.objectForKey(
            NSString(format: CircleCache.Keys.DynamicOrgIntegration, type.rawValue) as String
        ) as? Bool {
            return value
        }
        
        return nil
    }
}
