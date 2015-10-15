//
//  RecentSearchResults.swift
//  Circle
//
//  Created by Ravi Rani on 8/13/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import RealmSwift
import ProtobufRegistry

class RecentSearchResult: Object {

    enum ResultType: Int {
        case Profile = 1
        case Team
        case Location
        case ProfileStatus
    }
    
    dynamic var id = ""
    dynamic var object = NSData()
    dynamic var type = 0
    dynamic var updated = NSDate()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func createOrUpdate(recentSearchResult: RecentSearchResult) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(recentSearchResult, update: true)
            }
        }
        catch {
            print("Error: \(error)")
        }
    }
    
    static func getObjectFromResult(result: RecentSearchResult) -> AnyObject? {
        do {
            if let resultType = RecentSearchResult.ResultType(rawValue: result.type) {
                switch resultType {
                case .Profile:
                    return try Services.Profile.Containers.ProfileV1.parseFromData(result.object)
                    
                case .Team:
                    return try Services.Organization.Containers.TeamV1.parseFromData(result.object)
                    
                case .Location:
                    return try Services.Organization.Containers.LocationV1.parseFromData(result.object)
                    
                case .ProfileStatus:
                    return try Services.Profile.Containers.ProfileStatusV1.parseFromData(result.object)
                }
            }
        }
        catch {
            print("Error: \(error)")
        }
        
        return nil
    }
}
