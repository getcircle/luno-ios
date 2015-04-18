//
//  Media.swift
//  Circle
//
//  Created by Michael Hahn on 1/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

typealias StartImageUploadCompletionHandler = (instructions: Services.Media.Containers.UploadInstructionsV1?, error: NSError?) -> Void
typealias CompleteImageUploadCompletionHandler = (mediaURL: String?, error: NSError?) -> Void

extension Services.Media.Actions {
        
    class func startImageUpload(
        mediaType: Services.Media.Containers.Media.MediaTypeV1,
        key: String,
        completionHandler: StartImageUploadCompletionHandler?
    ) {
        let requestBuilder = Services.Media.Actions.StartImageUpload.RequestV1.builder()
        requestBuilder.mediaType = mediaType
        requestBuilder.media_key = key

        let client = ServiceClient(serviceName: "media")
        client.callAction(
            "start_image_upload",
            extensionField: Services.Registry.Requests.Media.startImageUpload(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Media.startImageUpload()
            ) as? Services.Media.Actions.StartImageUpload.ResponseV1
            completionHandler?(instructions: response?.uploadInstructions, error: error)
        }
    }
    
    class func completeImageUpload(
        mediaType: Services.Media.Containers.Media.MediaTypeV1,
        mediaKey: String,
        uploadId: String,
        uploadKey: String,
        completionHandler: CompleteImageUploadCompletionHandler?
    ) {
        let requestBuilder = Services.Media.Actions.CompleteImageUpload.RequestV1.builder()
        requestBuilder.mediaType = mediaType
        requestBuilder.media_key = mediaKey
        requestBuilder.upload_id = uploadId
        requestBuilder.upload_key = uploadKey
        
        let client = ServiceClient(serviceName: "media")
        client.callAction(
            "complete_image_upload",
            extensionField: Services.Registry.Requests.Media.completeImageUpload(),
            requestBuilder: requestBuilder
        ) { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Media.completeImageUpload()
            ) as? Services.Media.Actions.CompleteImageUpload.ResponseV1
            completionHandler?(mediaURL: response?.media_url, error: error)
        }
    }
    
    class func uploadProfileImage(profileId: String, image: UIImage, completionHandler: CompleteImageUploadCompletionHandler?) {
        Actions.startImageUpload(.Profile, key: profileId) { (instructions, error) -> Void in
            if let instructions = instructions {
                Alamofire.upload(.PUT, instructions.upload_url, UIImagePNGRepresentation(image))
                    .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        println("progress \(totalBytesWritten): \(totalBytesExpectedToWrite)")
                    }
                    .response { (request, response, _, error) -> Void in
                        Actions.completeImageUpload(
                            .Profile,
                            mediaKey: profileId,
                            uploadId: instructions.upload_id,
                            uploadKey: instructions.upload_key
                        ) { (mediaURL, error) -> Void in
                            completionHandler?(mediaURL: mediaURL, error: error)
                            return
                        }
                    }
            } else {
                println("encountered error: \(error)")
            }
        }
    }
}
