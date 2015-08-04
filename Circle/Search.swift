//
//  Search.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias SearchCompletionHandler = (results: Array<Services.Search.Containers.SearchResultV1>?, error: NSError?) -> Void

extension Services.Search.Actions {
    
    static func search(
        query: String,
        category: Services.Search.Containers.Search.CategoryV1? = nil,
        attribute: Services.Search.Containers.Search.AttributeV1? = nil,
        attributeValue: AnyObject? = nil,
        completionHandler: SearchCompletionHandler?
    ) {
        let requestBuilder = Services.Search.Actions.Search.RequestV1.builder()
        requestBuilder.query = query
        
        if let category = category {
            requestBuilder.category = category
        }
        
//        if let attribute = attribute, attributeValue = attributeValue {
//            requestBuilder.attribute = attribute
//            requestBuilder.attributeValue = attributeValue
//        }
//        
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
}
