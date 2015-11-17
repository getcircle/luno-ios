//
//  Search.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias SearchCompletionHandler = (query: String, results: Array<Services.Search.Containers.SearchResultV1>?, error: NSError?) -> Void

extension Services.Search.Actions {
    
    static func search(
        query: String,
        category: Services.Search.Containers.Search.CategoryV1? = nil,
        attribute: Services.Search.Containers.Search.AttributeV1? = nil,
        attributeValue: String? = nil,
        completionHandler: SearchCompletionHandler?
    ) {
        if let attribute = attribute, attributeValue = attributeValue {
            let requestBuilder = Services.Search.Actions.Search.RequestV1.Builder()
            requestBuilder.query = query
            
            if let category = category {
                requestBuilder.category = category
            }
            
            requestBuilder.attribute = attribute
            requestBuilder.attributeValue = attributeValue
            
            let client = ServiceClient(serviceName: "search")
            client.callAction(
                "search",
                extensionField: Services.Registry.Requests.Search.search(),
                requestBuilder: requestBuilder) { (_, _, wrappedResponse, error) -> Void in
                    let response = wrappedResponse?.response?.result.getExtension(
                        Services.Registry.Responses.Search.search()
                        ) as? Services.Search.Actions.Search.ResponseV1
                    completionHandler?(query: query, results: response?.results, error: error)
            }
        }
        else {
            // Use search_v2 for non-attribute searches
            let requestBuilder = Services.Search.Actions.SearchV2.RequestV1.Builder()
            requestBuilder.query = query
            
            if let category = category {
                requestBuilder.category = category
            }
            
            let client = ServiceClient(serviceName: "search")
            client.callAction(
                "search_v2",
                extensionField: Services.Registry.Requests.Search.searchV2(),
                requestBuilder: requestBuilder) { (_, _, wrappedResponse, error) -> Void in
                    let response = wrappedResponse?.response?.result.getExtension(
                        Services.Registry.Responses.Search.searchV2()
                        ) as? Services.Search.Actions.SearchV2.ResponseV1
                    completionHandler?(query: query, results: response?.results, error: error)
            }
        }
    }
}
