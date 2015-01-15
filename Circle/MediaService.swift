//
//  MediaService.swift
//  Circle
//
//  Created by Michael Hahn on 1/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Alamofire
import Foundation
import ProtobufRegistry

typealias StartImageUploadCompletionHandler = (instructions: MediaService.Containers.UploadInstructions?, error: NSError?) -> Void
typealias CompleteImageUploadCompletionHandler = (mediaURL: String?, error: NSError?) -> Void

extension MediaService {
    class Actions {
        
        class func startImageUpload(
            mediaObject: MediaService.MediaObject,
            key: String,
            completionHandler: StartImageUploadCompletionHandler
        ) {
            let requestBuilder = MediaService.StartImageUpload.Request.builder()
            requestBuilder.media_object = mediaObject
            requestBuilder.media_key = key

            let client = ServiceClient(serviceName: "media")
            client.callAction(
                "start_image_upload",
                extensionField: MediaServiceRequests_start_image_upload,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    MediaServiceRequests_start_image_upload
                ) as? MediaService.StartImageUpload.Response
                completionHandler(instructions: response?.upload_instructions, error: error)
            }
        }
        
        class func completeImageUpload(
            mediaObject: MediaService.MediaObject,
            mediaKey: String,
            uploadId: String,
            uploadKey: String,
            completionHandler: CompleteImageUploadCompletionHandler
        ) {
            let requestBuilder = MediaService.CompleteImageUpload.Request.builder()
            requestBuilder.media_object = mediaObject
            requestBuilder.media_key = mediaKey
            requestBuilder.upload_id = uploadId
            requestBuilder.upload_key = uploadKey
            
            let client = ServiceClient(serviceName: "media")
            client.callAction(
                "complete_image_upload",
                extensionField: MediaServiceRequests_complete_image_upload,
                requestBuilder: requestBuilder
            ) { (_, _, _, actionResponse, error) -> Void in
                let response = actionResponse?.result.getExtension(
                    MediaServiceRequests_complete_image_upload
                ) as? MediaService.CompleteImageUpload.Response
                completionHandler(mediaURL: response?.media_url, error: error)
            }
        }
        
        class func uploadProfileImage(profileId: String, image: UIImage, completionHandler: CompleteImageUploadCompletionHandler) {
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
                                completionHandler(mediaURL: mediaURL, error: error)
                            }
                        }
                } else {
                    println("encountered error: \(error)")
                }
            }
        }
    }
}
