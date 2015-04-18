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
    
    func getNextRequest(paginator: Soa.PaginatorV1) -> Soa.ServiceRequestV1 {
        let serviceRequestBuilder = toBuilder()
        serviceRequestBuilder.actions.removeAll(keepCapacity: true)
        for action in actions {
            let actionBuilder = action.toBuilder()
            let actionControlBuilder = action.control.toBuilder()
            let paginatorBuilder = paginator.toBuilder()
            paginatorBuilder.page = paginator.nextPage
            actionControlBuilder.paginator = paginatorBuilder.build()
            actionBuilder.control = actionControlBuilder.build()
            serviceRequestBuilder.actions.append(actionBuilder.build())
        }
        return serviceRequestBuilder.build()
    }
    
    func getPaginator() -> Soa.PaginatorV1 {
        let action = actions[0]
        return action.control.paginator
    }
    
}
