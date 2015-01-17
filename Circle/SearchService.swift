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

extension SearchService {
    class Actions {
        
        class SearchResults {
            var profiles: Array<ProfileService.Containers.Profile>?
            var teams: Array<OrganizationService.Containers.Team>?
            var addresses: Array<OrganizationService.Containers.Address>?
            var tags: Array<ProfileService.Containers.Tag>?
        }
        
        private class var whitespaceCharacterSet: NSCharacterSet {
            return NSCharacterSet.whitespaceCharacterSet()
        }
        
        class func search(query: String, completionHandler: SearchCompletionHandler?) {
            // Query the cache
            var (result, error) = search(query)
            completionHandler?(result: result, error: error)
            
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
        
        // MARK: - Helpers
        
        // given the query, search the local objects we have cached
        private class func search(query: String) -> (SearchResults?, NSError?){
            var searchTerms = query.componentsSeparatedByString(" ")
            let results = SearchResults()
            results.profiles = filterProfiles(searchTerms)
            results.teams = filterTeams(searchTerms)
            results.tags = filterTags(searchTerms)
            return (results, nil)
        }
        
        private class func filterProfiles(searchTerms: [String]) -> Array<ProfileService.Containers.Profile> {
            var andPredicates = [NSPredicate]()
            for searchTerm in searchTerms {
                let trimmedSearchTerm = trim(searchTerm)
                
                // Match first name
                var firstNamePredicate = NSComparisonPredicate(
                    leftExpression: NSExpression(forVariable: "first_name"),
                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                    modifier: .DirectPredicateModifier,
                    type: .BeginsWithPredicateOperatorType,
                    options: .CaseInsensitivePredicateOption
                )
                
                // Match last name
                var lastNamePredicate = NSComparisonPredicate(
                    leftExpression: NSExpression(forVariable: "last_name"),
                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                    modifier: .DirectPredicateModifier,
                    type: .BeginsWithPredicateOperatorType,
                    options: .CaseInsensitivePredicateOption
                )
                
                
                // Match title
                var titlePredicate = NSComparisonPredicate(
                    leftExpression: NSExpression(forVariable: "title"),
                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                    modifier: .DirectPredicateModifier,
                    type: .BeginsWithPredicateOperatorType,
                    options: .CaseInsensitivePredicateOption
                )
                
                // Match full title
                var fullTitlePredicate = NSComparisonPredicate(
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
                        fullTitlePredicate
                        ])
                )
            }
            
            let finalPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(andPredicates)
            return ObjectStore.sharedInstance.profiles.values.array.filter { finalPredicate.evaluateWithObject(
                $0,
                substitutionVariables: ["first_name": $0.first_name, "last_name": $0.last_name, "title": $0.title]
            )}
        }
        
        private class func filterTeams(searchTerms: [String]) -> Array<OrganizationService.Containers.Team> {
            var andPredicates = [NSPredicate]()
            for searchTerm in searchTerms {
                let trimmedSearchTerm = trim(searchTerm)
                
                var containsPredicate = NSComparisonPredicate(
                    leftExpression: NSExpression(forVariable: "name"),
                    rightExpression: NSExpression(forConstantValue: trimmedSearchTerm),
                    modifier: .DirectPredicateModifier,
                    type: .ContainsPredicateOperatorType,
                    options: .CaseInsensitivePredicateOption
                )
                
                andPredicates.append(
                    NSCompoundPredicate.orPredicateWithSubpredicates([
                        containsPredicate
                    ])
                )
            }
            
            let finalPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(andPredicates)
            return ObjectStore.sharedInstance.teams.values.array.filter { finalPredicate.evaluateWithObject(
                $0,
                substitutionVariables: ["name": $0.name]
            )}
        }
        
        private class func filterTags(searchTerms: [String]) -> Array<ProfileService.Containers.Tag> {
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
            return ObjectStore.sharedInstance.tags.values.array.filter {
                return finalPredicate.evaluateWithObject($0, substitutionVariables: ["name": $0.name])
            }
        }
        
        private class func trim(string: String) -> String {
            return string.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        }
        
    }
    
}

