//
//  UIImageViewExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

extension UIImageView {

    private func updateAcceptableContentTypes() {
        let serializer = AFImageResponseSerializer()
        serializer.acceptableContentTypes = serializer.acceptableContentTypes.setByAddingObjectsFromArray(["image/jpg", "image/pjpeg"])
        imageResponseSerializer = serializer
    }
    
    func setImageWithProfile(profile: ProfileService.Containers.Profile) {
        let request = NSURLRequest(URL: NSURL(string: profile.image_url)!)
        updateAcceptableContentTypes()
        
        if let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(request) {
            self.image = cachedImage
        }
        else {
            transform = CGAffineTransformMakeScale(0.0, 0.0)
            
            setImageWithURLRequest(request,
                placeholderImage: UIImage.imageFromColor(UIColor.darkGrayColor(), withRect: bounds),
                success: { (request, response, image) -> Void in
                    self.image = image
                    UIView.animateWithDuration(0.8,
                        delay: 0.0,
                        usingSpringWithDamping: 0.7,
                        initialSpringVelocity: 0.9,
                        options: UIViewAnimationOptions.CurveEaseInOut,
                        animations: { () -> Void in
                            self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 180.0/358.0)
                            UIView.animateWithDuration(0.1,
                                delay: 0.2,
                                options: UIViewAnimationOptions.CurveEaseInOut,
                                animations: { () -> Void in
                                    self.transform = CGAffineTransformIdentity
                                },
                                completion: nil
                            )
                        },
                        completion: nil
                    )
                    return
                },
                failure: { (request, response, error) -> Void in
                    println("failed to fetch image for profile: \(profile.full_name) - \(profile.image_url) error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    func setImageWithProfileImageURL(profileImageURL: String) {
        updateAcceptableContentTypes()
        setImageWithURL(
            NSURL(string: profileImageURL),
            placeholderImage: UIImage.imageFromColor(UIColor.darkGrayColor(), withRect: bounds)
        )
    }
}

