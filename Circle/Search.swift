//
//  Search.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias SearchCompletionHandler = (result: Services.Search.Actions.SearchResults?, error: NSError?) -> Void
typealias SearchResultsCompletionHandler = (results: Array<Services.Search.Containers.SearchResultsV1>?, error: NSError?) -> Void
typealias FilterCompletionHandler = (content: [AnyObject], error: NSError?) -> Void

extension Services.Search.Actions {

    class SearchResults {
        var profiles: Array<Services.Profile.Containers.ProfileV1>?
        var teams: Array<Services.Organization.Containers.TeamV1>?
        var addresses: Array<Services.Organization.Containers.AddressV1>?
        var interests: Array<Services.Profile.Containers.TagV1>?
        var skills: Array<Services.Profile.Containers.TagV1>?

        class var maxResultsPerCategory: Int {
            return 3
        }
        
        class var maxSuggestionsPerCategory: Int {
            return 3
        }
    }
    
    private static var whitespaceCharacterSet: NSCharacterSet {
        return NSCharacterSet.whitespaceCharacterSet()
    }
    
    static func search(query: String, showRecents: Bool, completionHandler: SearchCompletionHandler?) {
        // Query the cache
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            var (result, error) = self.search(query, showRecents: showRecents)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler?(result: result, error: error)
                return
            })
        })
        
        // Send a search request to the servers
//            let requestBuilder = Services.Search.Containers.Search.Search.RequestV1.builder()
//            requestBuilder.query = query
//            let client = ServiceClient(serviceName: "search")
//            client.callAction("search", extensionField: SearchSoa.ServiceRequestV1s_search, requestBuilder: requestBuilder) {
//                (_, _, _, actionResponse, error) -> Void in
//                let response = actionResponse?.result.getExtension(SearchSoa.ServiceResponseV1s_search) as? Services.Search.Containers.Search.Search.ResponseV1
//                SearchCache.sharedInstance.update(response?.profiles, teams: response?.teams, addresses: response?.addresses)
//                completionHandler(profiles: response?.profiles, teams: response?.teams, addresses: response?.addresses)
//            }
    }
    
    static func filter(
        query: String,
        category: Services.Search.Containers.Search.CategoryV1,
        toFilter: [AnyObject],
        completionHandler: FilterCompletionHandler?
    ) {
            
    }
    
    static func search(query: String, completionHandler: SearchResultsCompletionHandler?) {
        let requestBuilder = Services.Search.Actions.Search.RequestV1.builder()
        requestBuilder.query = query
        
        let client = ServiceClient(serviceName: "search")
        client.callAction(
            "search",
            extensionField: Services.Registry.Requests.Search.search(),
            requestBuilder: requestBuilder) { (_, _, wrappedResponse, error) -> Void in
                let response = wrappedResponse?.response?.result.getExtension(
                    Services.Registry.Responses.Search.search()
                ) as? Services.Search.Actions.Search.ResponseV1
                completionHandler?(results: response?.results, error: error)
        }
    }
    
    static func search(
        query: String,
        category: Services.Search.Containers.Search.CategoryV1,
        attribute: Services.Search.Containers.Search.AttributeV1?,
        attributeValue: AnyObject?,
        objects withObjects: [AnyObject]? = nil,
        completionHandler: SearchCompletionHandler?
    ) {
        // Query the cache
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            let (result, error) = self.search(query, category: category, attribute: attribute, attributeValue: attributeValue, objects: withObjects)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler?(result: result, error: error)
                return
            })
        })
    }
    
    // MARK: - Helpers
    
    private static func searchTermsFromQuery(query: String) -> [String] {
        return query.componentsSeparatedByString(" ")
    }
        
    private static func search(
        query: String,
        category: Services.Search.Containers.Search.CategoryV1,
        attribute: Services.Search.Containers.Search.AttributeV1?,
        attributeValue: AnyObject?,
        objects: [AnyObject]?
    ) -> (SearchResults?, NSError?) {
        
        let searchTerms = searchTermsFromQuery(query)
        let results = SearchResults()
        
        switch category {
        case .Profiles:
            var toFilter: Array<Services.Profile.Containers.ProfileV1>
            if attribute != nil && attributeValue != nil {
                toFilter = ObjectStore.sharedInstance.getProfilesForAttribute(attribute!, value: attributeValue!)
            } else if objects != nil {
                toFilter = objects as! Array<Services.Profile.Containers.ProfileV1>
            } else {
                toFilter = ObjectStore.sharedInstance.profiles.values.array
            }
            results.profiles = filterProfiles(searchTerms, toFilter: toFilter)
        case .Teams:
            results.teams = filterTeams(searchTerms)
        case .Skills:
            results.skills = filterTags(searchTerms, toFilter: ObjectStore.sharedInstance.skills)
        default: break
        }
        
        return (results, nil)
    }
    
    // given the query, search the local objects we have cached
    private static func search(query: String, showRecents: Bool) -> (SearchResults?, NSError?) {
        
        let results = SearchResults()
        
        // Show recent profile visits as suggestions if string is empty
        if query.trimWhitespace() == "" && showRecents {
            if let recentProfileIDs = CircleCache.sharedInstance.objectForKey(CircleCache.Keys.RecentProfileVisits) as? [String] {
                let matchedProfiles = filterProfiles(profileIDs: recentProfileIDs)
                results.profiles = Array(matchedProfiles[0..<min(SearchResults.maxSuggestionsPerCategory, matchedProfiles.count)])
                results.teams = Array<Services.Organization.Containers.TeamV1>()
                results.interests = Array<Services.Profile.Containers.TagV1>()
                results.skills = Array<Services.Profile.Containers.TagV1>()
                return (results, nil)
            }
        }
        
        let searchTerms = searchTermsFromQuery(query)
        results.profiles = filterProfiles(searchTerms)
        results.teams = filterTeams(searchTerms)
        results.interests = filterTags(searchTerms, tagType: .Interest)
        results.skills = filterTags(searchTerms, tagType: .Skill)
        return (results, nil)
    }
    
    private static func filterProfiles(#profileIDs: [String]) -> Array<Services.Profile.Containers.ProfileV1> {
        var matchedProfiles = Array<Services.Profile.Containers.ProfileV1>()
        
        for profileID in profileIDs {
            if let profile = ObjectStore.sharedInstance.profiles[profileID] {
                matchedProfiles.append(profile)
            }
        }
        
        return matchedProfiles
    }
    
    private static func filterProfiles(
        searchTerms: [String],
        toFilter: Array<Services.Profile.Containers.ProfileV1>
    ) -> Array<Services.Profile.Containers.ProfileV1> {
        var andPredicates = [NSPredicate]()
        
        for searchTerm in searchTerms {
            let trimmedSearchTerm = trim(searchTerm)
            
            // Match first name
            let firstNamePredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "firstName"),
                rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                modifier: .DirectPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            
            // Match last name
            let lastNamePredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "lastName"),
                rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                modifier: .DirectPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            
            
            // Match title
            let titlePredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "title"),
                rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                modifier: .DirectPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            
            // Match email
            let emailPredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "email"),
                rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                modifier: .DirectPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            
            // Match full title
            let fullTitlePredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "title"),
                rightExpression: NSExpression(forConstantValue: " ".join(searchTerms)),
                modifier: .DirectPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            
            // Match each word of the title
            var titleWordMatchPredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "title_words"),
                rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                modifier: .AnyPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            
            andPredicates.append(
                NSCompoundPredicate.orPredicateWithSubpredicates([
                    firstNamePredicate,
                    lastNamePredicate,
                    titlePredicate,
                    emailPredicate,
                    fullTitlePredicate,
                    titleWordMatchPredicate
                ])
            )
        }
        
        let finalPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(andPredicates)
        return toFilter.filter { finalPredicate.evaluateWithObject(
            $0,
            substitutionVariables: [
                "firstName": $0.firstName,
                "lastName": $0.lastName,
                "title": $0.title,
                "email": $0.email,
                "title_words": $0.title.componentsSeparatedByString(" ")
            ])
        }
    }
    
    private static func filterProfiles(searchTerms: [String]) -> Array<Services.Profile.Containers.ProfileV1> {
        return filterProfiles(searchTerms, toFilter: ObjectStore.sharedInstance.profiles.values.array)
    }
    
    private static func filterTeams(searchTerms: [String]) -> Array<Services.Organization.Containers.TeamV1> {
        return filterTeams(searchTerms, toFilter: ObjectStore.sharedInstance.teams.values.array)
    }
    
    private static func filterTeams(
        searchTerms: [String],
        toFilter: Array<Services.Organization.Containers.TeamV1>
    ) -> Array<Services.Organization.Containers.TeamV1> {
        var orPredicates = [NSPredicate]()
        
        // Match full name
        var fullTeamNameMatchPredicate = NSComparisonPredicate(
            leftExpression: NSExpression(forVariable: "name"),
            rightExpression: NSExpression(forConstantValue: " ".join(searchTerms)),
            modifier: .DirectPredicateModifier,
            type: .BeginsWithPredicateOperatorType,
            options: .CaseInsensitivePredicateOption
        )
        orPredicates.append(fullTeamNameMatchPredicate)
        
        for searchTerm in searchTerms {
            let trimmedSearchTerm = trim(searchTerm)
            
            // Match begins with for each word
            var beginsWithPredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "name"),
                rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                modifier: .DirectPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            
            orPredicates.append(beginsWithPredicate)
            
            // Match each component of team name
            var fullTeamNameComponentMatchPredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "team_name_components"),
                rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                modifier: .AnyPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            orPredicates.append(fullTeamNameComponentMatchPredicate)
        }
        
        let finalPredicate = NSCompoundPredicate.orPredicateWithSubpredicates(orPredicates)
        return toFilter.filter { finalPredicate.evaluateWithObject(
            $0,
            substitutionVariables: ["name": $0.name, "team_name_components": $0.name.componentsSeparatedByString(" ")]
            )
        }
    }
    
    private static func filterTags(searchTerms: [String], tagType: Services.Profile.Containers.TagV1.TagTypeV1) -> Array<Services.Profile.Containers.TagV1> {
        var tags: Dictionary<String, Services.Profile.Containers.TagV1>
        switch tagType {
        case .Skill:
            tags = ObjectStore.sharedInstance.activeSkills
        default:
            tags = ObjectStore.sharedInstance.activeInterests
        }
        return filterTags(searchTerms, toFilter: tags)
    }
    
    private static func filterTags(searchTerms: [String], toFilter: Dictionary<String, Services.Profile.Containers.TagV1>) -> Array<Services.Profile.Containers.TagV1> {
        var andPredicates = [NSPredicate]()
        for searchTerm in searchTerms {
            let trimmedSearchTerm = trim(searchTerm)
            
            var beginsWithPredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "name"),
                rightExpression: NSExpression(forConstantValue: searchTerm),
                modifier: .DirectPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            
            andPredicates.append(
                NSCompoundPredicate.orPredicateWithSubpredicates([
                    beginsWithPredicate
                ])
            )
        }
        
        let finalPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(andPredicates)
        return toFilter.values.array.filter {
            return finalPredicate.evaluateWithObject($0, substitutionVariables: ["name": $0.name])
        }
    }
    
    private static func trim(string: String) -> String {
        return string.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
    }
    
}

