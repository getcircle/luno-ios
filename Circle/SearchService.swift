//
//  SearchService.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias SearchCompletionHandler = (result: SearchService.Actions.SearchResults?, error: NSError?) -> Void
typealias FilterCompletionHandler = (content: [AnyObject], error: NSError?) -> Void

extension SearchService {

    class Actions {

        class SearchResults {
            var profiles: Array<ProfileService.Containers.Profile>?
            var teams: Array<OrganizationService.Containers.Team>?
            var addresses: Array<OrganizationService.Containers.Address>?
            var interests: Array<ProfileService.Containers.Tag>?
            var skills: Array<ProfileService.Containers.Tag>?

            class var maxResultsPerCategory: Int {
                return 3
            }
            
            class var maxSuggestionsPerCategory: Int {
                return 3
            }
        }
        
        private class var whitespaceCharacterSet: NSCharacterSet {
            return NSCharacterSet.whitespaceCharacterSet()
        }
        
        class func search(query: String, completionHandler: SearchCompletionHandler?) {
            // Query the cache
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                var (result, error) = self.search(query)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler?(result: result, error: error)
                    return
                })
            })
            
            // Send a search request to the servers
//            let requestBuilder = SearchService.Search.Request.builder()
//            requestBuilder.query = query
//            let client = ServiceClient(serviceName: "search")
//            client.callAction("search", extensionField: SearchServiceRequests_search, requestBuilder: requestBuilder) {
//                (_, _, _, actionResponse, error) -> Void in
//                let response = actionResponse?.result.getExtension(SearchServiceResponses_search) as? SearchService.Search.Response
//                SearchCache.sharedInstance.update(response?.profiles, teams: response?.teams, addresses: response?.addresses)
//                completionHandler(profiles: response?.profiles, teams: response?.teams, addresses: response?.addresses)
//            }
        }
        
        class func filter(
            query: String,
            category: SearchService.Category,
            toFilter: [AnyObject],
            completionHandler: FilterCompletionHandler?
        ) {
                
        }
        
        class func search(
            query: String,
            category: SearchService.Category,
            attribute: SearchService.Attribute?,
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
        
        private class func searchTermsFromQuery(query: String) -> [String] {
            return query.componentsSeparatedByString(" ")
        }
            
        private class func search(
            query: String,
            category: SearchService.Category,
            attribute: SearchService.Attribute?,
            attributeValue: AnyObject?,
            objects: [AnyObject]?
        ) -> (SearchResults?, NSError?) {
            
            let searchTerms = searchTermsFromQuery(query)
            let results = SearchResults()
            
            switch category {
            case .People:
                var toFilter: Array<ProfileService.Containers.Profile>
                if attribute != nil && attributeValue != nil {
                    toFilter = ObjectStore.sharedInstance.getProfilesForAttribute(attribute!, value: attributeValue!)
                } else if objects != nil {
                    toFilter = objects as Array<ProfileService.Containers.Profile>
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
        private class func search(query: String) -> (SearchResults?, NSError?) {
            
            let results = SearchResults()
            
            // Show recent profile visits as suggestions if string is empty
            if query.trimWhitespace() == "" {
                if let recentProfileIDs = CircleCache.sharedInstance.objectForKey(CircleCache.Keys.RecentProfileVisits) as? [String] {
                    let matchedProfiles = filterProfiles(profileIDs: recentProfileIDs)
                    results.profiles = Array(matchedProfiles[0..<min(SearchResults.maxSuggestionsPerCategory, matchedProfiles.count)])
                    results.teams = Array<OrganizationService.Containers.Team>()
                    results.interests = Array<ProfileService.Containers.Tag>()
                    return (results, nil)
                }
            }
            
            let searchTerms = searchTermsFromQuery(query)
            results.profiles = filterProfiles(searchTerms)
            results.teams = filterTeams(searchTerms)
            results.interests = filterTags(searchTerms, tagType: .Interest)
            return (results, nil)
        }
        
        private class func filterProfiles(#profileIDs: [String]) -> Array<ProfileService.Containers.Profile> {
            var matchedProfiles = Array<ProfileService.Containers.Profile>()
            
            for profileID in profileIDs {
                if let profile = ObjectStore.sharedInstance.profiles[profileID] {
                    matchedProfiles.append(profile)
                }
            }
            
            return matchedProfiles
        }
        
        private class func filterProfiles(
            searchTerms: [String],
            toFilter: Array<ProfileService.Containers.Profile>
        ) -> Array<ProfileService.Containers.Profile> {
            var andPredicates = [NSPredicate]()
            for searchTerm in searchTerms {
                let trimmedSearchTerm = trim(searchTerm)
                
                // Match first name
                let firstNamePredicate = NSComparisonPredicate(
                    leftExpression: NSExpression(forVariable: "first_name"),
                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                    modifier: .DirectPredicateModifier,
                    type: .BeginsWithPredicateOperatorType,
                    options: .CaseInsensitivePredicateOption
                )
                
                // Match last name
                let lastNamePredicate = NSComparisonPredicate(
                    leftExpression: NSExpression(forVariable: "last_name"),
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
                
                andPredicates.append(
                    NSCompoundPredicate.orPredicateWithSubpredicates([
                        firstNamePredicate,
                        lastNamePredicate,
                        titlePredicate,
                        emailPredicate,
                        fullTitlePredicate
                        ])
                )
            }
            
            let finalPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(andPredicates)
            return toFilter.filter { finalPredicate.evaluateWithObject(
                $0,
                substitutionVariables: [
                    "first_name": $0.first_name,
                    "last_name": $0.last_name,
                    "title": $0.title,
                    "email": $0.email,
                ])
            }
        }
        
        private class func filterProfiles(searchTerms: [String]) -> Array<ProfileService.Containers.Profile> {
            return filterProfiles(searchTerms, toFilter: ObjectStore.sharedInstance.profiles.values.array)
        }
        
        private class func filterTeams(searchTerms: [String]) -> Array<OrganizationService.Containers.Team> {
            return filterTeams(searchTerms, toFilter: ObjectStore.sharedInstance.teams.values.array)
        }
        
        private class func filterTeams(
            searchTerms: [String],
            toFilter: Array<OrganizationService.Containers.Team>
        ) -> Array<OrganizationService.Containers.Team> {
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
        
        private class func filterTags(searchTerms: [String], tagType: ProfileService.TagType) -> Array<ProfileService.Containers.Tag> {
            var tags: Dictionary<String, ProfileService.Containers.Tag>
            switch tagType {
            case .Skill:
                tags = ObjectStore.sharedInstance.activeSkills
            default:
                tags = ObjectStore.sharedInstance.activeInterests
            }
            return filterTags(searchTerms, toFilter: tags)
        }
        
        private class func filterTags(searchTerms: [String], toFilter: Dictionary<String, ProfileService.Containers.Tag>) -> Array<ProfileService.Containers.Tag> {
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
        
        private class func trim(string: String) -> String {
            return string.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        }
        
    }
    
}

