//
//  Post.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-10.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias GetPostCompletionHandler = (post: Services.Post.Containers.PostV1?, error: NSError?) -> Void

extension Services.Post.Actions {
    
    private static func getPost(requestBuilder: AbstractMessageBuilder, completionHandler: GetPostCompletionHandler?) {
        let client = ServiceClient(serviceName: "post")
        client.callAction("get_post", extensionField: Services.Registry.Requests.Post.getPost(), requestBuilder: requestBuilder) {
            (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Post.getPost()
                ) as? Services.Post.Actions.GetPost.ResponseV1
            completionHandler?(post: response?.post, error: error)
        }
    }
    
    static func getPost(postId: String, completionHandler: GetPostCompletionHandler?) {
        let requestBuilder = Services.Post.Actions.GetPost.RequestV1.Builder()
        requestBuilder.id = postId
        getPost(requestBuilder, completionHandler: completionHandler)
    }

}

extension Services.Post.Containers.PostV1 {

    func getFormattedChangedDate() -> String? {
        return NSDateFormatter.dateFromTimestampString(changed)?.timeAgo()
    }

}
