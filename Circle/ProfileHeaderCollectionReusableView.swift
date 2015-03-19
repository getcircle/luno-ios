//
//  ProfileHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

protocol ProfileDetailSegmentedControlDelegate {
    func onButtonTouchUpInsideAtIndex(index: Int)
}

class ProfileHeaderCollectionReusableView: CircleCollectionReusableView {

    @IBOutlet weak private(set) var backgroundImageView: CircleImageView!
    @IBOutlet weak private(set) var containerView: UIView!
    @IBOutlet weak private(set) var nameLabel: UILabel!
    @IBOutlet weak private(set) var nameNavLabel: UILabel!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var titleNavLabel: UILabel!
    @IBOutlet weak private(set) var profileImage: CircleImageView!
    @IBOutlet weak private(set) var sectionsView: UIView!
    @IBOutlet weak private(set) var verifiedProfileButton: UIButton!
    @IBOutlet weak private(set) var daylightIndicatorImage: UIImageView!
    @IBOutlet weak private(set) var daylightIndicatorNavImage: UIImageView!
    
    var profileSegmentedControlDelegate: ProfileDetailSegmentedControlDelegate?
    var sections: [ProfileDetailView]? {
        didSet {
            if sections != nil {
                configureSegmentedControl(sections: sections!)
            }
        }
    }
    var tappedButton: UIButton?
    var tappedButtonIndex: Int?
    private(set) var visualEffectView: UIVisualEffectView?
    
    private var buttonContainerWidth: CGFloat = 0.0
    private var location: OrganizationService.Containers.Location?
    private var profile: ProfileService.Containers.Profile?
    
    private var sectionIndicatorView: UIView?
    private var sectionIndicatorLeftOffsetConstraint: NSLayoutConstraint?
    private var sectionIndicatorWidthConstraint: NSLayoutConstraint?
    private var sectionIndicatorViewIsAnimating = false
    private var segmentedControlButtons = [UIButton]()
    private var controlsConfigured = false
    
    private let buttonAttributes = [
        NSKernAttributeName: NSNumber(double: 2.0),
        NSForegroundColorAttributeName: UIColor.appSegmentedControlTitleNormalColor(),
        NSFontAttributeName: UIFont.appSegmentedControlTitleFont()
    ]
    private let sectionIndicatorBeginningWidth: CGFloat = 30.0

    
    override class var classReuseIdentifier: String {
        return "ProfileHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 240.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        profileImage.makeItCircular()
        backgroundImageView.addLabelIfImageLoadingFails = false
        nameNavLabel.alpha = 0.0
        titleNavLabel.alpha = 0.0
        configureVerifiedProfileButton()
        addBlurEffect()
        visualEffectView!.contentView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        containerView.autoMatchDimension(.Height, toDimension: .Height, ofView: backgroundImageView)
    }
    
    // MARK: - Configuration
    
    private func configureVerifiedProfileButton() {
        verifiedProfileButton.convertToTemplateImageForState(.Normal)
        verifiedProfileButton.tintColor = UIColor.whiteColor()
        verifiedProfileButton.backgroundColor = UIColor.appTintColor()
        verifiedProfileButton.makeItCircular()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if sectionIndicatorView?.frameWidth == 0.0 {
            sectionIndicatorLeftOffsetConstraint?.constant = segmentedControlButtons[selectedButtonIndex()].frameX
            sectionIndicatorWidthConstraint?.constant = segmentedControlButtons[selectedButtonIndex()].frameWidth
            adjustSectionIndicator(false)
        }
    }

    func setProfile(userProfile: ProfileService.Containers.Profile) {
        if profile == nil {
            profile = userProfile
            nameLabel.text = userProfile.first_name + " " + userProfile.last_name
            nameNavLabel.text = nameLabel.text
            titleLabel.text = userProfile.title
            titleNavLabel.text = titleLabel.text
            profileImage.setImageWithProfile(userProfile, successHandler: { (image) -> Void in
                self.profileImage.image = image
                if self.backgroundImageView.image != image {
                    self.backgroundImageView.image = image
                    self.addBlurEffect()
                }
            })
            verifiedProfileButton.hidden = !userProfile.verified
        }
    }

    func setOffice(office: OrganizationService.Containers.Location) {
        if location == nil {
            location = office
            let officeName = office.address.officeName()
            let officeStateAndCountry = (office.address.hasRegion ? office.address.region : "") + ", " + office.address.country_code
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
            } else {
                // TODO: - Remove hardcoded image
                profileImage.image = UIImage(named: "SF")
                backgroundImageView.image = UIImage(named: "SF")
                addBlurEffect()
            }
            verifiedProfileButton.hidden = true
        }
    }

    // MARK: - Segmented Control

    private func configureSegmentedControl(sections withSections: [ProfileDetailView]) {
        
        // Ensure we only configure the controls once
        if controlsConfigured {
            return
        } else {
            controlsConfigured = true
        }
        
        // Setup the segment buttons
        let buttonSegmentOffset: CGFloat = 0.5
        let width: CGFloat = (frame.width - (CGFloat(withSections.count - 1) * buttonSegmentOffset)) / CGFloat(withSections.count)
        buttonContainerWidth = width
        let buttonContainerSize = CGSizeMake(width, sectionsView.frameHeight)
        
        var previousButtonContainer: UIView?
        for section in withSections {
            let buttonContainerView = UIView(forAutoLayout: ())
            buttonContainerView.backgroundColor = UIColor.clearColor()
            buttonContainerView.opaque = true
            sectionsView.addSubview(buttonContainerView)
            buttonContainerView.autoSetDimensionsToSize(buttonContainerSize)

            let button = UIButton.buttonWithType(.Custom) as UIButton
            button.setTitleColor(UIColor.appSegmentedControlTitleNormalColor(), forState: .Normal)
            button.setTitleColor(UIColor.appSegmentedControlTitleSelectedColor(), forState: .Selected)
            button.tintColor = UIColor.appSegmentedControlTitleNormalColor()
            button.setAttributedTitle(
                NSAttributedString(string: section.title.uppercaseString, attributes: buttonAttributes), 
                forState: .Normal
            )
            
            button.addTarget(
                self,
                action: "segmentButtonPressed:", 
                forControlEvents: .TouchUpInside
            )
            
            buttonContainerView.addSubview(button)
            button.autoCenterInSuperview()
            
            if let previous = previousButtonContainer {
                buttonContainerView.autoPinEdge(.Left, toEdge: .Right, ofView: previous, withOffset: buttonSegmentOffset)
            } else {
                buttonContainerView.autoPinEdge(.Left, toEdge: .Left, ofView: sectionsView)
            }
            buttonContainerView.autoPinEdge(.Top, toEdge: .Top, ofView: sectionsView)
            previousButtonContainer = buttonContainerView
            segmentedControlButtons.append(button)
        }
        
        // Setup the section indicator view
        sectionIndicatorView = UIView.newAutoLayoutView()
        sectionsView.addSubview(sectionIndicatorView!)
        
        selectButtonAtIndex(0)
        sectionIndicatorView?.backgroundColor = UIColor.appTintColor()
        sectionIndicatorView?.autoSetDimension(.Height, toSize: 1.5)
        sectionIndicatorView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5.0)
        sectionIndicatorWidthConstraint = sectionIndicatorView?.autoSetDimension(.Width, toSize: segmentedControlButtons[0].frameWidth)
        sectionIndicatorLeftOffsetConstraint = sectionIndicatorView?.autoPinEdgeToSuperviewEdge(.Left, withInset: segmentedControlButtons[0].frameX)
    }
    
    func segmentButtonPressed(sender: AnyObject!) {
        if let tappedButtonIndex = tappedButtonIndex {
            profileSegmentedControlDelegate?.onButtonTouchUpInsideAtIndex(tappedButtonIndex)
        }
    }
    
    func updateTitle(title: String, forSegmentAtIndex index: Int) {
        if segmentedControlButtons.count > index {
            segmentedControlButtons[index].setAttributedTitle(
                NSAttributedString(
                    string: title.uppercaseString, 
                    attributes: buttonAttributes
                ),
                forState: .Normal
            )
        }
    }
    
    func beginMovingSectionIndicatorView(contentOffset: CGPoint) {
        sectionIndicatorViewIsAnimating = true
        sectionIndicatorWidthConstraint?.constant = sectionIndicatorBeginningWidth
        adjustSectionIndicator(true)
    }
    
    func updateSectionIndicatorView(contentOffset: CGPoint) {

        // We aren't animating the width of the sectionIndicator if someone taps on the segmented controls
        let currentSelectedButton = segmentedControlButtons[selectedButtonIndex()]
        var animationOffset = (currentSelectedButton.frameWidth / 2) + currentSelectedButton.frameX - (sectionIndicatorBeginningWidth / 2.0)
        if !sectionIndicatorViewIsAnimating {
            animationOffset = currentSelectedButton.frameX
        }
        sectionIndicatorLeftOffsetConstraint?.constant = (contentOffset.x / CGFloat(sections!.count)) + animationOffset
        adjustSectionIndicator(true)
    }
    
    func finishMovingSelectionIndicatorView(contentOffset: CGPoint) {
        let buttonIndexToBeSelected = Int(contentOffset.x/frameWidth)
        if buttonIndexToBeSelected < segmentedControlButtons.count {
            sectionIndicatorWidthConstraint?.constant = segmentedControlButtons[buttonIndexToBeSelected].frameWidth
            sectionIndicatorLeftOffsetConstraint?.constant = contentOffset.x / CGFloat(sections!.count) + segmentedControlButtons[buttonIndexToBeSelected].frameX
            selectButtonAtIndex(buttonIndexToBeSelected)
        }
        adjustSectionIndicator(true)
        sectionIndicatorViewIsAnimating = false
    }
    
    private func adjustSectionIndicator(animated: Bool) {
        UIView.animateWithDuration(
            animated ? 0.3 : 0.0,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.sectionIndicatorView?.superview?.layoutIfNeeded()
                return
            },
            completion: nil
        )
    }
    
    private func selectButtonAtIndex(index: Int) {
        if index < segmentedControlButtons.count {
            for button in segmentedControlButtons {
                button.selected = false
            }

            segmentedControlButtons[index].selected = true
        }
    }
    
    private func selectedButtonIndex() -> Int {
        for (index, button) in enumerate(segmentedControlButtons) {
            if button.selected == true {
                return index
            }
        }
        
        return 0
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
            let profileImageFractionValue = 1.0 - (contentOffset.y - minOffsetToMakeChanges)/profileImage.frameY
            profileImage.alpha = profileImageFractionValue
            verifiedProfileButton.alpha = profileImageFractionValue

            if profileImageFractionValue >= 0 {
                var transform = CGAffineTransformMakeScale(profileImageFractionValue, profileImageFractionValue)
                profileImage.transform = transform
                verifiedProfileButton.transform = transform
                verifiedProfileButton.center = CGPointMake(profileImage.center.x + (profileImage.frameWidth/2.0), verifiedProfileButton.center.y)
            }
            
            // Reduce opacity of the name and title label at a faster pace
            let titleLabelAlpha = 1.0 - contentOffset.y/(titleLabel.frameY - 40.0)
            let nameLabelAlpha = 1.0 - contentOffset.y/(nameLabel.frameY - 40.0)
            let sectionsAlpha = 1.0 - contentOffset.y/(sectionsView.frameY - 40.0)
            titleLabel.alpha = titleLabelAlpha
            nameLabel.alpha = nameLabelAlpha
            daylightIndicatorImage.alpha = titleLabelAlpha
            nameNavLabel.alpha = sectionsAlpha <= 0.0 ? nameNavLabel.alpha + 1/20 : 0.0
            titleNavLabel.alpha = sectionsAlpha <= 0.0 ? titleNavLabel.alpha + 1/20 : 0.0
            daylightIndicatorNavImage.alpha = titleNavLabel.alpha
            sectionsView.alpha = sectionsAlpha
        }
        else {
            // Change alpha faster for profile image
            let profileImageAlpha = max(0.0, 1.0 - -contentOffset.y/80.0)
            
            // Change it slower for everything else
            let otherViewsAlpha = max(0.0, 1.0 - -contentOffset.y/120.0)
            nameLabel.alpha = otherViewsAlpha
            verifiedProfileButton.alpha = profileImageAlpha
            nameNavLabel.alpha = 0.0
            titleNavLabel.alpha = 0.0
            daylightIndicatorNavImage.alpha = titleNavLabel.alpha
            titleLabel.alpha = otherViewsAlpha
            profileImage.alpha = profileImageAlpha
            visualEffectView?.alpha = otherViewsAlpha
            sectionsView.alpha = otherViewsAlpha
            profileImage.transform = CGAffineTransformIdentity
            verifiedProfileButton.transform = CGAffineTransformIdentity
            verifiedProfileButton.center = CGPointMake(profileImage.center.x + (profileImage.frameWidth/2.0), verifiedProfileButton.center.y)
        }
    }
}
