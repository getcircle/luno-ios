//
//  CircleImageView.swift
//  Circle
//
//  Created by Ravi Rani on 1/20/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import Kingfisher
import ProtobufRegistry

class CircleImageView: UIImageView {

    struct ProfileColorsHolder {
        static var colors = [String: UIColor]()
    }
    
    class var imageOptions: KingfisherOptionsInfo {
        return [KingfisherOptionsInfoKey.Options: KingfisherOptions.BackgroundDecode]
    }
    
    override var image: UIImage? {
        didSet {
            if image != nil {
                imageLabel.alpha = 0
            }
        }
    }

    var imageText: String? {
        didSet {
            if imageText != nil {
                imageLabel.alpha = 1.0
                image = nil
                imageLabel.text = imageText
            }
        }
    }
    
    // Set this boolean to control globally whether the image loading should be animated
    // This is honored over any internal condition around image caching.
    var animateImageLoading = true
    var addLabelIfImageLoadingFails = true
    var imageProfileIdentifier: String?
    private var imageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImageLabelFont()
    }
    
    private func customInit() {
        imageLabel = UILabel(forAutoLayout: ())
        imageLabel.backgroundColor = UIColor.clearColor()
        imageLabel.textAlignment = .Center
        imageLabel.textColor = UIColor.whiteColor()
        addSubview(imageLabel)
        bringSubviewToFront(imageLabel)
        imageLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        setImageLabelFont()
    }

    func setImageWithProfile(profile: Services.Profile.Containers.ProfileV1, successHandler: ((image: UIImage) -> Void)? = nil) {
        if let imageURL = NSURL(string: profile.imageUrl) where profile.imageUrl.trimWhitespace() != "" {
            let isImageCached = isImageInCache(imageURL)
            if !isImageCached {
                transform = CGAffineTransformMakeScale(0.0, 0.0)
            }
            
            kf_setImageWithURL(imageURL,
                placeholderImage: nil,
                optionsInfo: self.dynamicType.imageOptions,
                progressBlock: nil,
                completionHandler: { (image, error, cacheType, imageURL) -> Void in
                    if let image = image where error == nil {
                        if let imageID = self.imageProfileIdentifier {
                            if imageID != profile.id {
                                self.transform = CGAffineTransformIdentity
                                return
                            }
                        }
                        
                        if let successCallback = successHandler {
                            self.transform = CGAffineTransformIdentity
                            successCallback(image: image)
                        }
                        else {
                            self.image = image
                            self.makeImageVisible(!isImageCached)
                        }
                    }
                    else {
                        self.addImageLabelForProfile(profile)
                        self.makeImageVisible(false)
                        println("failed to fetch image for profile: \(profile.fullName) - \(profile.imageUrl) error: \(error?.localizedDescription)")
                    }
                }
            )
        }
        else {
            addImageLabelForProfile(profile)
        }
    }
    
    func setImageWithLocation(location: Services.Organization.Containers.LocationV1, successHandler: ((image: UIImage) -> Void)? = nil) {
        if let imageURL = NSURL(string: location.imageUrl) where location.imageUrl.trimWhitespace() != "" {
            let isImageCached = isImageInCache(imageURL)
            if !isImageCached {
                transform = CGAffineTransformMakeScale(0.0, 0.0)
            }
            kf_setImageWithURL(imageURL,
                placeholderImage: nil,
                optionsInfo: self.dynamicType.imageOptions,
                progressBlock: nil,
                completionHandler: { (image, error, cacheType, imageURL) -> Void in
                    if let image = image where error == nil {
                        if let successCallback = successHandler {
                            self.transform = CGAffineTransformIdentity
                            successCallback(image: image)
                        }
                        else {
                            self.image = image
                            if !isImageCached {
                                self.makeImageVisible(!isImageCached)
                            }
                        }
                    }
                    else {
                        self.addImageLabelForLocation(location)
                        self.makeImageVisible(false)
                        println("failed to fetch image for location: \(location.name) - \(location.imageUrl) error: \(error?.localizedDescription)")
                    }
                }
            )
        }
        else {
            addImageLabelForLocation(location)
        }
    }
    
    func setImageWithURL(url: NSURL, animated: Bool, successHandler: ((image: UIImage) -> Void)? = nil) {
        var shouldAnimate = animated
        let isImageCached = isImageInCache(url)
        shouldAnimate = isImageCached ? false : shouldAnimate
        if shouldAnimate {
            alpha = 0.0
        }
        
        kf_setImageWithURL(url,
            placeholderImage: nil,
            optionsInfo: self.dynamicType.imageOptions,
            progressBlock: nil,
            completionHandler: { (image, error, cacheType, imageURL) -> Void in
                if let image = image where error == nil {
                    if let successCallback = successHandler {
                        successCallback(image: image)
                    }
                    else {
                        self.image = image
                    }
                    UIView.animateWithDuration(shouldAnimate ? 0.3 : 0.0, animations: { () -> Void in
                        self.alpha = 1.0
                    })
                }
            }
        )
    }
    
    func setImageWithProfileImageURL(profileImageURL: String) {
        if let imageURL = NSURL(string: profileImageURL) {
            kf_setImageWithURL(
                imageURL,
                placeholderImage: nil,
                optionsInfo: self.dynamicType.imageOptions
            )
        }
    }
    
    private func addImageLabelForProfile(profile: Services.Profile.Containers.ProfileV1) {
        if let imageID = imageProfileIdentifier where addLabelIfImageLoadingFails && imageID == profile.id {
            imageText = profile.firstName[0] + profile.lastName[0]
            var appProfileImageBackgroundColor = ProfileColorsHolder.colors[profile.id] ?? UIColor.appProfileImageBackgroundColor()
            ProfileColorsHolder.colors[profile.id] = appProfileImageBackgroundColor
            imageLabel.backgroundColor = appProfileImageBackgroundColor
        }
    }
    
    private func addImageLabelForLocation(location: Services.Organization.Containers.LocationV1) {
        if self.addLabelIfImageLoadingFails {
            self.imageText = location.name[0]
            self.imageLabel.backgroundColor = UIColor.appProfileImageBackgroundColor()
        }
    }
    
    private func isImageInCache(url: NSURL) -> Bool {
        if let urlString = url.absoluteString {
            return KingfisherManager.sharedManager.cache.isImageCachedForKey(urlString).cached
        }
        
        return false
    }
    
    private func makeImageVisible(animated: Bool) {
        if !(animated && animateImageLoading) {
            transform = CGAffineTransformIdentity
        }
        else {
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
        }
    }
    
    // MARK: - Helper
    
    private func setImageLabelFont() {
        imageLabel.font = UIFont(name: "Avenir-Light", size: min(frame.width / 2.5, 22.0))
    }
}
