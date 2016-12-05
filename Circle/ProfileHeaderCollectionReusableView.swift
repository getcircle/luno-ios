//
//  ProfileHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileHeaderCollectionReusableView: CircleCollectionReusableView {

    @IBOutlet weak private(set) var backgroundImageView: CircleImageView!
    @IBOutlet weak private(set) var containerView: UIView!
    @IBOutlet weak private(set) var nameLabel: UILabel!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var profileImage: CircleImageView!
    @IBOutlet weak private(set) var profileImageCenterYConstraint: NSLayoutConstraint!
    
    // Secondary Info
    
    @IBOutlet weak private(set) var secondaryInfoLabel: UILabel!
    
    private(set) var visualEffectView: UIVisualEffectView?

    private var location: Services.Organization.Containers.LocationV1?
    private var profile: Services.Profile.Containers.ProfileV1?
    private var secondaryViews = [UIView]()
    
    override class var classReuseIdentifier: String {
        return "ProfileHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 258.0
    }
    
    class var heightWithoutSecondaryInfo: CGFloat {
        return 250.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Don't rasterize because this view is frequently re-drawn which makes rasterizing it costly.
        layer.shouldRasterize = false

        // Initialization code
        addBlurEffect()
        secondaryViews.appendContentsOf([secondaryInfoLabel])
        configureLabels()
        configureContainerView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImage.layer.borderWidth = 0.0
    }
    
    // MARK: - Configuration
    
    private func configureLabels() {
        
        for label in [nameLabel, titleLabel, secondaryInfoLabel] {
            label.text = ""
        }
    }

    private func configureContainerView() {
        profileImage.makeItCircular()
        backgroundImageView.addLabelIfImageLoadingFails = false
        visualEffectView!.contentView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        containerView.autoMatchDimension(.Height, toDimension: .Height, ofView: backgroundImageView)
        containerView.backgroundColor = UIColor(red: 85, green: 85, blue: 85)
    }

    func setProfile(
        userProfile: Services.Profile.Containers.ProfileV1,
        location userLocation: Services.Organization.Containers.LocationV1?,
        team userTeam: Services.Organization.Containers.TeamV1?
    ) {
        if let hireDateString = userProfile.getFormattedHireDate() {
            secondaryInfoLabel.text = hireDateString
        }

        containerView.backgroundColor = UIColor.clearColor()
        nameLabel.text = userProfile.nameWithNickName()
        let title = userProfile.hasDisplayTitle ? userProfile.displayTitle : userProfile.title
        titleLabel.attributedText = NSAttributedString(
            string: title.uppercaseString,
            attributes: [NSKernAttributeName: 2.0]
        )
        let hasProfileImageChanged = profile?.imageUrl != userProfile.imageUrl
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
            })
        }
    }
    
    private func loadLargeProfileImage(userProfile: Services.Profile.Containers.ProfileV1) {
        self.backgroundImageView.setLargerProfileImage(userProfile)
    }

    func setLocation(office: Services.Organization.Containers.LocationV1) {
        containerView.backgroundColor = UIColor.clearColor()
        let officeName = office.officeName()
        var officeTitleText = office.cityRegion()
        if office.profileCount == 1 {
            officeTitleText += " (" +
                NSLocalizedString("1 Person", comment: "Title indicating there is one person at an office") +
            ")"
        }
        else {
            officeTitleText += " (" + (NSString(format:
                NSLocalizedString("%d People", comment: "Title indicating there are %d people at an office"),
                office.profileCount
            ) as String) + ") "
        }
        
        nameLabel.text = officeName
        titleLabel.attributedText = NSAttributedString(
            string: officeTitleText.localizedUppercaseString(),
            attributes: [NSKernAttributeName: 2.0]
        )
        secondaryInfoLabel.text = office.officeCurrentDateAndTimeLabel()
        profileImage.image = UIImage(named: "hero_office")
        profileImage.makeItCircular(true)
        
        var imageUpdated = true
        if let location = location where office.imageUrl == location.imageUrl && office.hasImageUrl {
            imageUpdated = false
        }
        
        if office.hasImageUrl && imageUpdated {
            backgroundImageView.imageProfileIdentifier = office.id
            backgroundImageView.setImageWithLocation(office) { (image) -> Void in
                if self.backgroundImageView != image {
                    self.backgroundImageView.image = image
                    self.addBlurEffect()
                }
            }
        }
        location = office
    }
    
    func setTeam(team: Services.Organization.Containers.TeamV1) {
        hideSecondaryViews()
        nameLabel.text = team.getName()
        
        containerView.backgroundColor = UIColor.clearColor()
        let teamCounts = team.getTeamCounts().uppercaseString
        titleLabel.attributedText = NSAttributedString(
            string: teamCounts.localizedUppercaseString(),
            attributes: [NSKernAttributeName: 2.0]
        )
        profileImage.image = UIImage(named: "hero_group")
        profileImage.makeItCircular(true)
        
        backgroundImageView.imageProfileIdentifier = team.id
        backgroundImageView.setImageWithTeam(team) { (image) -> Void in
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
            visualEffectView!.translatesAutoresizingMaskIntoConstraints = false
            insertSubview(visualEffectView!, aboveSubview: backgroundImageView)
            visualEffectView!.autoSetDimensionsToSize(UIScreen.mainScreen().bounds.size)
        }
    }
    
    func adjustViewForScrollContentOffset(contentOffset: CGPoint) {
        // Change alpha faster for profile image
        let profileImageAlpha = max(0.0, 1.0 - -contentOffset.y/80.0)
        
        // Change it slower for everything else
        let otherViewsAlpha = max(0.0, 1.0 - -contentOffset.y/120.0)
        visualEffectView?.alpha = otherViewsAlpha
        containerView.alpha = otherViewsAlpha
        profileImage.alpha = profileImageAlpha
        profileImage.transform = CGAffineTransformIdentity
    }
}
