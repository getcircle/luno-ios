//
//  CircleImageView.swift
//  Circle
//
//  Created by Ravi Rani on 1/20/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import AFNetworking
import ProtobufRegistry

class CircleImageView: UIImageView {

    struct ProfileColorsHolder {
        static var colors = [String: UIColor]()
    }
    
    let timeoutInterval = 5.0
        
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
        updateAcceptableContentTypes()
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
    
    private func updateAcceptableContentTypes() {
        let serializer = AFImageResponseSerializer()
        serializer.acceptableContentTypes = serializer.acceptableContentTypes.union(["image/jpg", "image/pjpeg"])
        imageResponseSerializer = serializer
    }
    
    func setImageWithProfile(profile: Services.Profile.Containers.ProfileV1, successHandler: ((image: UIImage) -> Void)? = nil) {
        var profileImageURL = profile.imageUrl
        if profile.smallImageUrl.trimWhitespace() != "" {
            profileImageURL = profile.smallImageUrl
        }
        
        if let imageURL = NSURL(string: profileImageURL) where profileImageURL.trimWhitespace() != "" {
            let imageURLRequest = NSMutableURLRequest(URL: imageURL)
            imageURLRequest.timeoutInterval = timeoutInterval
            let isImageCached = isImageInCache(imageURL)
            if !isImageCached {
                transform = CGAffineTransformMakeScale(0.0, 0.0)
            }
            
            setImageWithURLRequest(
                imageURLRequest, 
                placeholderImage: nil, 
                success: { (urlRequest, response, image) -> Void in
                    if let image = image {
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
                    
                },
                failure: { (imageURLRequest, response, error) -> Void in
                    self.addImageLabelForProfile(profile)
                    self.makeImageVisible(false)
                    if let response = response {
                        println("Response \(response.statusCode) \(response)")
                    }
                    println("failed to fetch image for profile: \(profileImageURL) error: \(error?.localizedDescription)")
                }
            )
        }
        else {
            addImageLabelForProfile(profile)
        }
    }
    
    func setImageWithLocation(location: Services.Organization.Containers.LocationV1, successHandler: ((image: UIImage) -> Void)? = nil) {
        if let imageURL = NSURL(string: location.imageUrl) where location.imageUrl.trimWhitespace() != "" {
            let imageURLRequest = NSMutableURLRequest(URL: imageURL)
            imageURLRequest.timeoutInterval = timeoutInterval
            setImageWithURLRequest(
                imageURLRequest,
                placeholderImage: nil,
                success: { (urlRequest, response, image) -> Void in
                    if let image = image {
                        
                        if let imageID = self.imageProfileIdentifier {
                            if imageID != location.id {
                                return
                            }
                        }

                        if let successCallback = successHandler {
                            successCallback(image: image)
                        }
                        else {
                            self.image = image
                        }
                    }
                },
                failure: { (imageURLRequest, response, error) -> Void in
                    self.addImageLabelForLocation(location)
                    if let response = response {
                        println("Response \(response.statusCode) \(response)")
                    }

                    println("failed to fetch image for location: \(location.imageUrl) error: \(error?.localizedDescription)")
                }
            )
        }
        else {
            addImageLabelForLocation(location)
        }
    }

    func setImageWithTeam(team: Services.Organization.Containers.TeamV1, successHandler: ((image: UIImage) -> Void)? = nil) {
        if let imageURL = NSURL(string: team.imageUrl) where team.imageUrl.trimWhitespace() != "" {
            let imageURLRequest = NSMutableURLRequest(URL: imageURL)
            imageURLRequest.timeoutInterval = timeoutInterval
            setImageWithURLRequest(
                imageURLRequest,
                placeholderImage: nil,
                success: { (urlRequest, response, image) -> Void in
                    if let image = image {
                        if let imageID = self.imageProfileIdentifier {
                            if imageID != team.id {
                                return
                            }
                        }

                        if let successCallback = successHandler {
                            successCallback(image: image)
                        }
                        else {
                            self.image = image
                        }
                    }
                },
                failure: { (imageURLRequest, response, error) -> Void in
                    self.addImageLabelForTeam(team)
                    if let response = response {
                        println("Response \(response.statusCode) \(response)")
                    }

                    println("failed to fetch image for team: \(team.imageUrl) error: \(error?.localizedDescription)")
                }
            )
        }
        else {
            addImageLabelForTeam(team)
        }
    }

    func setImageWithURL(imageURL: NSURL, animated: Bool, successHandler: ((image: UIImage) -> Void)? = nil) {
        var shouldAnimate = animated
        let isImageCached = isImageInCache(imageURL)
        shouldAnimate = isImageCached ? false : shouldAnimate
        if shouldAnimate {
            alpha = 0.0
        }
        
        let imageURLRequest = NSMutableURLRequest(URL: imageURL)
        imageURLRequest.timeoutInterval = timeoutInterval
        setImageWithURLRequest(
            imageURLRequest,
            placeholderImage: nil,
            success: { (urlRequest, response, image) -> Void in
                if let image = image {
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
            },
            failure: nil
        )
    }
    
    func setLargerProfileImage(profile: Services.Profile.Containers.ProfileV1, successHandler: ((image: UIImage) -> Void)? = nil) {
        if let imageURL = NSURL(string: profile.imageUrl) {
            if successHandler != nil {
                let urlRequest = NSMutableURLRequest(URL: imageURL)
                urlRequest.timeoutInterval = timeoutInterval
                setImageWithURLRequest(
                    urlRequest, 
                    placeholderImage: nil, 
                    success: { (request, response, image) -> Void in
                        if let imageID = self.imageProfileIdentifier where imageID == profile.id {
                            successHandler!(image: image)
                        }
                    },
                    failure: { (request, response, error) -> Void in
                        println("Error setLargerProfileImage \(error)")
                    }
                )
            } else {
                setImageWithURL(imageURL)
            }
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

    private func addImageLabelForTeam(team: Services.Organization.Containers.TeamV1) {
        if self.addLabelIfImageLoadingFails {
            self.imageText = team.name[0]
            self.imageLabel.backgroundColor = UIColor.appTeamHeaderBackgroundColor(team)
        }
    }

    private func isImageInCache(url: NSURL) -> Bool {
        if let urlString = url.absoluteString {
            let imageURLRequest = NSMutableURLRequest(URL: url)
            imageURLRequest.timeoutInterval = timeoutInterval
            if let cachedUIImage = UIImageView.sharedImageCache().cachedImageForRequest(imageURLRequest) {
                return true
            }
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
