//
//  ServiceRequestExtension.swift
//  Circle
//
//  Created by Michael Hahn on 3/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension ServiceRequest {
    
    func getNextRequest(paginator: Paginator) -> ServiceRequest {
        let serviceRequestBuilder = toBuilder()
        serviceRequestBuilder.actions.removeAll(keepCapacity: true)
        for action in actions {
            let actionBuilder = action.toBuilder()
            let actionControlBuilder = action.control.toBuilder()
            let paginatorBuilder = paginator.toBuilder()
            paginatorBuilder.page = paginator.next_page
            actionControlBuilder.paginator = paginatorBuilder.build()
            actionBuilder.control = actionControlBuilder.build()
            serviceRequestBuilder.actions.append(actionBuilder.build())
        }
        return serviceRequestBuilder.build()
    }
    
    func getFirstPaginator() -> Paginator {
        let action = actions[0]
        return action.control.paginator
    }
    
}
