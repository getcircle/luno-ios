//
//  ProfileHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileHeaderCollectionReusableView: DetailHeaderCollectionReusableView {

    @IBOutlet weak private(set) var backgroundImageView: CircleImageView!
    @IBOutlet weak private(set) var containerView: UIView!
    @IBOutlet weak private(set) var nameLabel: UILabel!
    @IBOutlet weak private(set) var nameNavLabel: UILabel!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var titleNavLabel: UILabel!
    @IBOutlet weak private(set) var profileImage: CircleImageView!
    @IBOutlet weak private(set) var profileImageCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var verifiedProfileButton: UIButton!
    @IBOutlet weak private(set) var daylightIndicatorImage: UIImageView!
    @IBOutlet weak private(set) var daylightIndicatorNavImage: UIImageView!
    
    // Secondary Info
    
    @IBOutlet weak private(set) var hireDateLabel: UILabel!
    
    private(set) var visualEffectView: UIVisualEffectView?

    private var location: Services.Organization.Containers.LocationV1?
    private var profile: Services.Profile.Containers.ProfileV1?
    private var secondaryViews = [UIView]()
    
    override class var classReuseIdentifier: String {
        return "ProfileHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 260.0
    }
    
    class var heightWithoutSecondaryInfo: CGFloat {
        return 240.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        addBlurEffect()
        secondaryViews.extend([hireDateLabel])
        configureLabels()
        configureContainerView()
        configureVerifiedProfileButton()
    }
    
    // MARK: - Configuration
    
    private func configureLabels() {
        
        for label in [nameLabel, nameNavLabel, titleLabel, titleNavLabel, hireDateLabel] {
            label.text = ""
        }
    }

    private func configureContainerView() {
        profileImage.makeItCircular()
        backgroundImageView.addLabelIfImageLoadingFails = false
        nameNavLabel.alpha = 0.0
        titleNavLabel.alpha = 0.0
        visualEffectView!.contentView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        containerView.autoMatchDimension(.Height, toDimension: .Height, ofView: backgroundImageView)
        containerView.backgroundColor = UIColor(red: 85, green: 85, blue: 85)
    }
    
    private func configureVerifiedProfileButton() {
        verifiedProfileButton.convertToTemplateImageForState(.Normal)
        verifiedProfileButton.tintColor = UIColor.whiteColor()
        verifiedProfileButton.backgroundColor = UIColor.appTintColor()
        verifiedProfileButton.makeItCircular()
        verifiedProfileButton.hidden = true
    }

    func setProfile(
        userProfile: Services.Profile.Containers.ProfileV1,
        location userLocation: Services.Organization.Containers.LocationV1?,
        team userTeam: Services.Organization.Containers.TeamV1?
    ) {
        if let hireDateString = userProfile.getFormattedHireDate() {
            hireDateLabel.text = hireDateString
        }

        if let userLocation = userLocation {
            containerView.backgroundColor = UIColor.clearColor()
        }
        
        var titleText = userProfile.title
        if let userTeam = userTeam where count(userTeam.name) > 0 {
            titleText += " (" + userTeam.name + ")"
        }
        
        nameLabel.text = userProfile.nameWithNickName()
        nameNavLabel.text = nameLabel.text
        titleLabel.text = titleText
        titleNavLabel.text = titleLabel.text
        var hasProfileImageChanged = profile?.imageUrl != userProfile.imageUrl
        profile = userProfile
        profileImage.imageProfileIdentifier = userProfile.id
        if hasProfileImageChanged {
            profileImage.setImageWithProfile(userProfile, successHandler: { (image) -> Void in
                self.profileImage.image = image
                if self.backgroundImageView.image != image {
                    self.backgroundImageView.image = image
                    self.loadLargeProfileImage(userProfile)
                    self.addBlurEffect()
                }
                self.verifiedProfileButton.hidden = !userProfile.verified
            })
        }
    }
    
    private func loadLargeProfileImage(userProfile: Services.Profile.Containers.ProfileV1) {
        self.backgroundImageView.setLargerProfileImage(userProfile)
    }

    func setLocations(office: Services.Organization.Containers.LocationV1) {
        hideSecondaryViews()
        containerView.backgroundColor = UIColor.clearColor()
        let officeName = office.officeName()
        let officeStateAndCountry = (office.hasRegion ? office.region : "") + ", " + office.countryCode
        nameLabel.text = officeName
        nameNavLabel.text = officeName
        titleLabel.text = office.officeCurrentDateAndTimeLabel()
        titleNavLabel.text = office.officeCurrentTimeLabel(nil)
        if let indicatorImage = office.officeDaylightIndicator() {
            daylightIndicatorImage.alpha = 1.0
            daylightIndicatorImage.image = indicatorImage
            daylightIndicatorImage.tintColor = titleLabel.textColor
            daylightIndicatorNavImage.image = indicatorImage
            daylightIndicatorNavImage.tintColor = titleNavLabel.textColor
        }
        
        self.profileImage.contentMode = .ScaleAspectFill
        
        var imageUpdated = true
        if let location = location where office.imageUrl == location.imageUrl && office.hasImageUrl {
            imageUpdated = false
        }
        
        if office.hasImageUrl && imageUpdated {
            profileImage.imageProfileIdentifier = office.id
            profileImage.setImageWithLocation(office) { (image) -> Void in
                self.profileImage.image = image
                if self.backgroundImageView != image {
                    self.backgroundImageView.image = image
                    self.addBlurEffect()
                }
            }
        }
        verifiedProfileButton.hidden = true
        location = office
    }
    
    func setTeam(team: Services.Organization.Containers.TeamV1) {
        hideSecondaryViews()
        nameLabel.text = team.getName()
        nameNavLabel.text = team.getName()
        
        containerView.backgroundColor = UIColor.clearColor()
        let teamCounts = team.getTeamCounts().uppercaseString
        titleLabel.attributedText = NSAttributedString(
            string: teamCounts,
            attributes: [NSKernAttributeName: 0.5]
        )
        titleNavLabel.text = teamCounts
        
        let teamColor = UIColor.appTeamHeaderBackgroundColor(team)
        profileImage.imageProfileIdentifier = team.id
        profileImage.setImageWithTeam(team) { (image) -> Void in
            self.profileImage.image = image
            if self.backgroundImageView != image {
                self.backgroundImageView.image = image
                self.addBlurEffect()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func hideSecondaryViews() {
        for view in secondaryViews {
            view.hidden = true
        }
        profileImageCenterYConstraint.constant = 15.0
        profileImage.setNeedsUpdateConstraints()
        profileImage.layoutIfNeeded()
    }
    
    private func addBlurEffect() {
        if visualEffectView == nil {
            let blurEffect = UIBlurEffect(style: .Dark)
            visualEffectView = UIVisualEffectView(effect: blurEffect)
            visualEffectView!.setTranslatesAutoresizingMaskIntoConstraints(false)
            insertSubview(visualEffectView!, aboveSubview: backgroundImageView)
            visualEffectView!.autoSetDimensionsToSize(UIScreen.mainScreen().bounds.size)
        }
    }
    
    func adjustViewForScrollContentOffset(contentOffset: CGPoint) {
        let minOffsetToMakeChanges: CGFloat = 20.0
        
        // Do not change anything unless user scrolls up more than 20 points
        if contentOffset.y > minOffsetToMakeChanges {
            
            // Scale down the image and reduce opacity
            let profileImageFractionValue = 1.0 - (contentOffset.y - minOffsetToMakeChanges)/profileImage.frame.origin.y
            profileImage.alpha = profileImageFractionValue
            verifiedProfileButton.alpha = profileImageFractionValue

            if profileImageFractionValue >= 0 {
                var transform = CGAffineTransformMakeScale(profileImageFractionValue, profileImageFractionValue)
                profileImage.transform = transform
                verifiedProfileButton.transform = transform
                verifiedProfileButton.center = CGPointMake(profileImage.center.x + (profileImage.frame.width/2.0), verifiedProfileButton.center.y)
            }
            
            let delta: CGFloat = 40.0
            let navViews = Set([nameNavLabel, titleNavLabel, daylightIndicatorNavImage])
            let excludedViews = Set([profileImage, verifiedProfileButton])
            for view: UIView in (containerView.subviews as! [UIView]) {
                if excludedViews.contains(view) {
                    continue
                }
                
                let alpha = 1.0 - contentOffset.y/(view.frame.origin.y - delta)
                if navViews.contains(view) {
                    view.alpha = alpha <= 0.0 ? view.alpha + 1/20 : 0.0
                }
                else {
                    view.alpha = alpha
                }
            }
            
            editImageButton?.alpha = nameLabel.alpha
        }
        else {
            // Change alpha faster for profile image
            let profileImageAlpha = max(0.0, 1.0 - -contentOffset.y/80.0)
            
            // Change it slower for everything else
            let otherViewsAlpha = max(0.0, 1.0 - -contentOffset.y/120.0)
            nameNavLabel.alpha = 0.0
            titleNavLabel.alpha = 0.0
            daylightIndicatorNavImage.alpha = titleNavLabel.alpha
            visualEffectView?.alpha = otherViewsAlpha
            containerView.alpha = otherViewsAlpha
            editImageButton?.alpha = otherViewsAlpha
            profileImage.alpha = profileImageAlpha
            profileImage.transform = CGAffineTransformIdentity
            verifiedProfileButton.alpha = profileImageAlpha
            verifiedProfileButton.transform = CGAffineTransformIdentity
            verifiedProfileButton.center = CGPointMake(profileImage.center.x + (profileImage.frame.width/2.0), verifiedProfileButton.center.y)
        }
    }
}
