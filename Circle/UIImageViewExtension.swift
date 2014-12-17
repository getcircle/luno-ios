//
//  UIImageViewExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

extension UIImageView {

    // It is assumed that the image would be 1:1 aspect ratio
    func makeItCircular(addBorder: Bool) {
        layer.cornerRadiusWithMaskToBounds(bounds.size.width/2.0)
        
        if addBorder {
            layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3).CGColor
            layer.borderWidth = 1.0
        }
    }

    func setImageWithPerson(person: Person!) {
        let request = NSURLRequest(URL: NSURL(string: person.profileImageURL)!)
        
        if let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(request) {
            self.image = cachedImage
        }
        else {
            transform = CGAffineTransformMakeScale(0.0, 0.0)

            setImageWithURLRequest(request,
                placeholderImage: UIImage(named: "DefaultPerson"),
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
                nil
            )
        }
    }
    
    func setImageWithProfileImageURL(profileImageURL: String) {
        setImageWithURL(
            NSURL(string: profileImageURL),
            placeholderImage: UIImage(named: "DefaultPerson")
        )
    }
}

