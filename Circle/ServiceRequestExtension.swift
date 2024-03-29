//
//  Soa.ServiceRequestV1Extension.swift
//  Circle
//
//  Created by Michael Hahn on 3/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension Soa.ServiceRequestV1 {
    
    func getNextRequest(paginator: Soa.PaginatorV1) throws -> Soa.ServiceRequestV1? {
        let serviceRequestBuilder = try toBuilder()
        serviceRequestBuilder.actions.removeAll(keepCapacity: true)
        for action in actions {
            let actionBuilder = try action.toBuilder()
            let actionControlBuilder = try action.control.toBuilder()
            let paginatorBuilder = try paginator.toBuilder()
            paginatorBuilder.page = paginator.nextPage
            actionControlBuilder.paginator = try paginatorBuilder.build()
            actionBuilder.control = try actionControlBuilder.build()
            serviceRequestBuilder.actions.append(try actionBuilder.build())
        }
        return try serviceRequestBuilder.build()
    }
    
    func getPaginator() -> Soa.PaginatorV1 {
        let action = actions[0]
        return action.control.paginator
    }
    
}
