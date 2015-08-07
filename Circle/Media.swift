//
//  Media.swift
//  Circle
//
//  Created by Michael Hahn on 1/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import Alamofire
import ProtobufRegistry

typealias StartImageUploadCompletionHandler = (instructions: Services.Media.Containers.UploadInstructionsV1?, error: NSError?) -> Void
typealias CompleteImageUploadCompletionHandler = (mediaURL: String?, error: NSError?) -> Void

extension Services.Media.Actions {
        
    static func startImageUpload(
        mediaType: Services.Media.Containers.Media.MediaTypeV1,
        key: String,
        completionHandler: StartImageUploadCompletionHandler?
    ) {
        let requestBuilder = Services.Media.Actions.StartImageUpload.RequestV1.builder()
        requestBuilder.mediaType = mediaType
        requestBuilder.mediaKey = key

        let client = ServiceClient(serviceName: "media")
        client.callAction(
            "start_image_upload",
            extensionField: Services.Registry.Requests.Media.startImageUpload(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Media.startImageUpload()
            ) as? Services.Media.Actions.StartImageUpload.ResponseV1
            completionHandler?(instructions: response?.uploadInstructions, error: error)
        }
    }
    
    static func completeImageUpload(
        mediaType: Services.Media.Containers.Media.MediaTypeV1,
        mediaKey: String,
        uploadId: String,
        uploadKey: String,
        completionHandler: CompleteImageUploadCompletionHandler?
    ) {
        let requestBuilder = Services.Media.Actions.CompleteImageUpload.RequestV1.builder()
        requestBuilder.mediaType = mediaType
        requestBuilder.mediaKey = mediaKey
        requestBuilder.uploadId = uploadId
        requestBuilder.uploadKey = uploadKey
        
        let client = ServiceClient(serviceName: "media")
        client.callAction(
            "complete_image_upload",
            extensionField: Services.Registry.Requests.Media.completeImageUpload(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Responses.Media.completeImageUpload()
            ) as? Services.Media.Actions.CompleteImageUpload.ResponseV1
            completionHandler?(mediaURL: response?.mediaUrl, error: error)
        }
    }
    
    static func uploadImage(
        image: UIImage,
        forMediaType mediaType: Services.Media.Containers.Media.MediaTypeV1,
        withKey mediaKey: String,
        andCompletionHandler completionHandler: CompleteImageUploadCompletionHandler?
    ) {
        startImageUpload(mediaType, key: mediaKey) { (instructions, error) -> Void in
            if let instructions = instructions {
                Alamofire.upload(.PUT, instructions.uploadUrl, data: UIImagePNGRepresentation(image))
                    .progress(closure: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
                        println("progress \(totalBytesWritten): \(totalBytesExpectedToWrite)")
                    })
                    .response({ (request, response, _, error) -> Void in
                        self.completeImageUpload(
                            mediaType,
                            mediaKey: mediaKey,
                            uploadId: instructions.uploadId,
                            uploadKey: instructions.uploadKey
                        ) { (mediaURL, error) -> Void in
                                completionHandler?(mediaURL: mediaURL, error: error)
                                return
                        }
                    })
            } else {
                println("encountered error: \(error)")
            }
        }
    }
}
