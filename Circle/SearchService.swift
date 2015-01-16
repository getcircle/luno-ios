//
//  SearchService.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias SearchCompletionHandler = (
    profiles: Array<ProfileService.Containers.Profile>?,
    teams: Array<OrganizationService.Containers.Team>?,
    addresses: Array<OrganizationService.Containers.Address>?
) -> Void

extension SearchService {
    class Actions {
        
        class SearchResults {
            var profiles: Array<ProfileService.Containers.Profile>?
            var teams: Array<OrganizationService.Containers.Team>?
            var addresses: Array<OrganizationService.Containers.Address>?
        }
        
        private class var whitespaceCharacterSet: NSCharacterSet {
            return NSCharacterSet.whitespaceCharacterSet()
        }
        
        class func search(query: String, completionHandler: SearchCompletionHandler?) {
            // Query the cache
            var (cache, error) = search(query)
            completionHandler?(profiles: cache?.profiles, teams: cache?.teams, addresses: cache?.addresses)
            
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
            return (results, nil)
        }
        
        private class func filterProfiles(searchTerms: [String]) -> Array<ProfileService.Containers.Profile> {
            var andPredicates = [NSPredicate]()
            for searchTerm in searchTerms {
                let trimmedSearchTerm = searchTerm.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
                
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
        
    }
    
}

