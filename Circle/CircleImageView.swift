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

    private func updateAcceptableContentTypes() {
        let serializer = AFImageResponseSerializer()
        serializer.acceptableContentTypes = serializer.acceptableContentTypes.union(["image/jpg", "image/pjpeg"])
        imageResponseSerializer = serializer
    }

    func setImageWithProfile(profile: Services.Profile.Containers.ProfileV1, successHandler: ((image: UIImage) -> Void)? = nil) {
        let request = NSURLRequest(URL: NSURL(string: profile.imageUrl)!)
        updateAcceptableContentTypes()
        
        if let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(request) {
            if let successCallback = successHandler {
                successCallback(image: cachedImage)
            }
            else {
                image = cachedImage
            }
        }
        else {
            transform = CGAffineTransformMakeScale(0.0, 0.0)
            setImageWithURLRequest(request,
                placeholderImage: UIImage.imageFromColor(UIColor.darkGrayColor(), withRect: bounds),
                success: { (request, response, image) -> Void in
                    
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
                        self.makeImageVisible(true)
                    }
                },
                failure: { (request, response, error) -> Void in
                    if self.addLabelIfImageLoadingFails {
                        self.imageText = profile.firstName[0] + profile.lastName[0]
                        var appProfileImageBackgroundColor = ProfileColorsHolder.colors[profile.id] ?? UIColor.appProfileImageBackgroundColor()
                        ProfileColorsHolder.colors[profile.id] = appProfileImageBackgroundColor
                        self.imageLabel.backgroundColor = appProfileImageBackgroundColor
                    }
                    
                    self.makeImageVisible(false)
                    println("failed to fetch image for profile: \(profile.fullName) - \(profile.imageUrl) error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    func setImageWithLocation(location: Services.Organization.Containers.LocationV1, successHandler: ((image: UIImage) -> Void)? = nil) {
        let request = NSURLRequest(URL: NSURL(string: location.imageUrl)!)
        updateAcceptableContentTypes()
        
        if let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(request) {
            if let successCallback = successHandler {
                successCallback(image: cachedImage)
            }
            else {
                image = cachedImage
            }
        }
        else {
            transform = CGAffineTransformMakeScale(0.0, 0.0)
            setImageWithURLRequest(request,
                placeholderImage: UIImage.imageFromColor(UIColor.darkGrayColor(), withRect: bounds),
                success: { (request, response, image) -> Void in
                    if let successCallback = successHandler {
                        self.transform = CGAffineTransformIdentity
                        successCallback(image: image)
                    }
                    else {
                        self.image = image
                        self.makeImageVisible(true)
                    }
                },
                failure: { (request, response, error) -> Void in
                    if self.addLabelIfImageLoadingFails {
                        self.imageText = location.name[0]
                        self.imageLabel.backgroundColor = UIColor.appProfileImageBackgroundColor()
                    }
                    
                    self.makeImageVisible(false)
                    println("failed to fetch image for location: \(location.name) - \(location.imageUrl) error: \(error.localizedDescription)")
                }
            )
        }
    }
    
    func setImageWithURL(url: NSURL, animated: Bool, successHandler: ((image: UIImage) -> Void)? = nil) {
        let request = NSURLRequest(URL: url)
        updateAcceptableContentTypes()
        if animated {
            alpha = 0.0
        }
        
        if let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(request) {
            if let successCallback = successHandler {
                successCallback(image: cachedImage)
            }
            else {
                image = cachedImage
                if animated {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.alpha = 1.0
                    })
                }
            }
        } else {
            setImageWithURLRequest(request,
                placeholderImage: UIImage.imageFromColor(UIColor.darkGrayColor(), withRect: bounds),
                success: { (request, response, image) -> Void in
                    if let successCallback = successHandler {
                        successCallback(image: image)
                    }
                    else {
                        self.image = image
                    }
                    if animated {
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.alpha = 1.0
                        })
                    }
                },
                failure: nil
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
    
    private func makeImageVisible(animated: Bool) {
        if !animated {
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
