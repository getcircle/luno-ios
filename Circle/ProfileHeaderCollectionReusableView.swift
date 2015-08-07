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
    @IBOutlet weak private(set) var verifiedProfileButton: UIButton!
    @IBOutlet weak private(set) var daylightIndicatorImage: UIImageView!
    @IBOutlet weak private(set) var daylightIndicatorNavImage: UIImageView!
    
    private(set) var visualEffectView: UIVisualEffectView?

    private var location: Services.Organization.Containers.LocationV1?
    private var profile: Services.Profile.Containers.ProfileV1?
    
    override class var classReuseIdentifier: String {
        return "ProfileHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 240.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        addBlurEffect()
        configureLabels()
        configureContainerView()
        configureVerifiedProfileButton()
    }
    
    // MARK: - Configuration
    
    private func configureLabels() {
        
        for label in [nameLabel, nameNavLabel, titleLabel, titleNavLabel] {
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
    }
    
    private func configureVerifiedProfileButton() {
        verifiedProfileButton.convertToTemplateImageForState(.Normal)
        verifiedProfileButton.tintColor = UIColor.whiteColor()
        verifiedProfileButton.backgroundColor = UIColor.appTintColor()
        verifiedProfileButton.makeItCircular()
        verifiedProfileButton.hidden = true
    }

    func setProfile(userProfile: Services.Profile.Containers.ProfileV1) {
        var hasProfileImageChanged = profile?.imageUrl != userProfile.imageUrl
        profile = userProfile
        nameLabel.text = userProfile.nameWithNickName()
        nameNavLabel.text = nameLabel.text
        titleLabel.text = userProfile.title
        titleNavLabel.text = titleLabel.text
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

    func setOffice(office: Services.Organization.Containers.LocationV1) {
        if location == nil {
            if let address = office.address {
                
                location = office
                let officeName = office.address.officeName()
                let officeStateAndCountry = (office.address.hasRegion ? office.address.region : "") + ", " + office.address.countryCode
                nameLabel.text = officeName
                nameNavLabel.text = officeName
                titleLabel.text = office.address.officeCurrentDateAndTimeLabel()
                titleNavLabel.text = office.address.officeCurrentTimeLabel(nil)
                if let indicatorImage = office.address.officeDaylightIndicator() {
                    daylightIndicatorImage.alpha = 1.0
                    daylightIndicatorImage.image = indicatorImage
                    daylightIndicatorImage.tintColor = titleLabel.textColor
                    daylightIndicatorNavImage.image = indicatorImage
                    daylightIndicatorNavImage.tintColor = titleNavLabel.textColor
                }
                
                self.profileImage.contentMode = .ScaleAspectFill
                if location!.hasImageUrl {
                    profileImage.setImageWithLocation(location!) { (image) -> Void in
                        self.profileImage.image = image
                        if self.backgroundImageView != image {
                            self.backgroundImageView.image = image
                            self.addBlurEffect()
                        }
                    }
                }
                verifiedProfileButton.hidden = true
            }
        }
    }
    
    func setTeam(team: Services.Organization.Containers.TeamV1) {
        nameLabel.text = team.name
        nameNavLabel.text = team.name
        
        let teamCounts = team.getTeamCounts().uppercaseString
        titleLabel.attributedText = NSAttributedString(
            string: teamCounts,
            attributes: [NSKernAttributeName: 0.5]
        )
        titleNavLabel.text = teamCounts
        
        let teamColor = UIColor.appTeamHeaderBackgroundColor(team)
        profileImage.setImageWithTeam(team) { (image) -> Void in
            self.profileImage.image = image
            if self.backgroundImageView != image {
                self.backgroundImageView.image = image
                self.addBlurEffect()
            }
        }
    }
    
    // MARK: - Helpers
    
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
            
            // Reduce opacity of the name and title label at a faster pace
            let titleLabelAlpha = 1.0 - contentOffset.y/(titleLabel.frame.origin.y - 40.0)
            let nameLabelAlpha = 1.0 - contentOffset.y/(nameLabel.frame.origin.y - 40.0)
            let sectionsAlpha = 1.0 - contentOffset.y/(nameNavLabel.frame.origin.y - 40.0)
            titleLabel.alpha = titleLabelAlpha
            nameLabel.alpha = nameLabelAlpha
            daylightIndicatorImage.alpha = titleLabelAlpha
            editImageButton?.alpha = titleLabelAlpha
            nameNavLabel.alpha = sectionsAlpha <= 0.0 ? nameNavLabel.alpha + 1/20 : 0.0
            titleNavLabel.alpha = sectionsAlpha <= 0.0 ? titleNavLabel.alpha + 1/20 : 0.0
            daylightIndicatorNavImage.alpha = titleNavLabel.alpha
        }
        else {
            // Change alpha faster for profile image
            let profileImageAlpha = max(0.0, 1.0 - -contentOffset.y/80.0)
            
            // Change it slower for everything else
            let otherViewsAlpha = max(0.0, 1.0 - -contentOffset.y/120.0)
            verifiedProfileButton.alpha = profileImageAlpha
            nameNavLabel.alpha = 0.0
            titleNavLabel.alpha = 0.0
            daylightIndicatorNavImage.alpha = titleNavLabel.alpha
            profileImage.alpha = profileImageAlpha
            visualEffectView?.alpha = otherViewsAlpha
            containerView.alpha = otherViewsAlpha
            profileImage.transform = CGAffineTransformIdentity
            verifiedProfileButton.transform = CGAffineTransformIdentity
            verifiedProfileButton.center = CGPointMake(profileImage.center.x + (profileImage.frame.width/2.0), verifiedProfileButton.center.y)
        }
    }
}
