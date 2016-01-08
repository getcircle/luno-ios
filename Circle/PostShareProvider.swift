//
//  PostShareProvider.swift
//  Luno
//
//  Created by Ravi Rani on 12/29/15.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class PostShareProvider: NSObject, UIActivityItemSource {

    private(set) var post: Services.Post.Containers.PostV1
    
    init(post withPost: Services.Post.Containers.PostV1) {
        post = withPost
    }
    
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        
        if let currentProfile = AuthenticationViewController.getLoggedInUserProfile(), currentOrg = AuthenticationViewController.getLoggedInUserOrganization() {
            
            if activityType == UIActivityTypeMail {
                let postURL = currentOrg.getURL(String(
                    format: "post/%@/?ls=app_post_share_email",
                    arguments: [post.id]
                ))
                let mailBody = String(format: "<html><body>Check out \"%@\" by %@ on Luno!<br/><br/>%@<br/><br/>Cheers,<br/>%@%@</body></html>", arguments: [
                    post.title,
                    post.byProfile.firstName,
                    postURL,
                    currentProfile.firstName,
                    UIViewController.getSentFromString()
                ])
                
                return mailBody
            }
            else {
                print(activityType)
                let postURL = currentOrg.getURL(String(
                    format: "post/%@/?ls=app_post_share&type=%@",
                    arguments: [post.id, activityType]
                ))
                let shareContent = String(format: "%@\n%@", arguments: [post.title, postURL])
                return shareContent
            }
        }
        
        return post.title
    }
    
    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return post.title
    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        return "Check out \"" + post.title + "\" on Luno"
    }
}
