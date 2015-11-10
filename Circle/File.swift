//
//  File.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-09.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias GetFilesCompletionHandler = (files: [Services.File.Containers.FileV1]?, error: NSError?) -> Void

extension Services.File.Actions {
    
    private static func getFiles(requestBuilder: AbstractMessageBuilder, completionHandler: GetFilesCompletionHandler?) {
        let client = ServiceClient(serviceName: "file")
        client.callAction("get_files", extensionField: Services.Registry.Requests.File.getFiles(), requestBuilder: requestBuilder) {
            (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.File.getFiles()
                ) as? Services.File.Actions.GetFiles.ResponseV1
            completionHandler?(files: response?.files, error: error)
        }
    }
    
    static func getFiles(fileIds: [String], completionHandler: GetFilesCompletionHandler?) {
        let requestBuilder = Services.File.Actions.GetFiles.RequestV1.Builder()
        requestBuilder.ids = fileIds
        getFiles(requestBuilder, completionHandler: completionHandler)
    }
    
}
