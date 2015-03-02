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

    @IBOutlet weak private(set) var backgroundImage: UIImageView!
    @IBOutlet weak private(set) var nameLabel: UILabel!
    @IBOutlet weak private(set) var nameNavLabel: UILabel!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var titleNavLabel: UILabel!
    @IBOutlet weak private(set) var profileImage: CircleImageView!
    @IBOutlet weak private(set) var sectionsView: UIView!
    @IBOutlet weak private(set) var verifiedProfileButton: UIButton!
    
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
    private var profile: ProfileService.Containers.Profile?
    private var sectionIndicatorView: UIView?
    private var sectionIndicatorLeftOffsetConstraint: NSLayoutConstraint?
    private var sectionIndicatorWidthConstraint: NSLayoutConstraint?
    private var sectionIndicatorViewIsAnimating = false
    private var segmentedControlButtons = [UIButton]()
    
    private let buttonAttributes = [
        NSKernAttributeName: NSNumber(double: 2.0),
        NSForegroundColorAttributeName: UIColor.appSegmentedControlTitleNormalColor(),
        NSFontAttributeName: UIFont.appSegmentedControlTitleFont()
    ]
    private let sectionIndicatorBeginningWidth: CGFloat = 30.0

    
    override class var classReuseIdentifier: String {
        return "ProfileHeaderView"
    }
    
    override class var height: CGFloat {
        return 270.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        profileImage.makeItCircular()
        nameNavLabel.alpha = 0.0
        titleNavLabel.alpha = 0.0
        configureVerifiedProfileButton()
    }
    
    // MARK: - Configuration
    
    private func configureVerifiedProfileButton() {
        verifiedProfileButton.convertToTemplateImageForState(.Normal)
        verifiedProfileButton.tintColor = UIColor.whiteColor()
        verifiedProfileButton.makeItCircular()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if sectionIndicatorView?.frameWidth == 0.0 {
            sectionIndicatorLeftOffsetConstraint?.constant = segmentedControlButtons[selectedButtonIndex()].frameX
            sectionIndicatorWidthConstraint?.constant = segmentedControlButtons[selectedButtonIndex()].frameWidth
            animateSectionIndicator()
        }
    }

    func setProfile(userProfile: ProfileService.Containers.Profile) {
        profile = userProfile
        nameLabel.text = userProfile.first_name + " " + userProfile.last_name
        nameNavLabel.text = nameLabel.text
        titleLabel.text = userProfile.title
        titleNavLabel.text = titleLabel.text
        profileImage.setImageWithProfile(userProfile)
        
        if let imageURL = NSURL(string: userProfile.image_url) {
            let urlImageRequest = NSURLRequest(URL: imageURL)
            backgroundImage.setImageWithURLRequest(
                urlImageRequest,
                placeholderImage: UIImage.imageFromColor(UIColor.darkGrayColor(), withRect: bounds),
                success: { (request, response, image) -> Void in
                    if self.backgroundImage.image != image {
                        self.backgroundImage.image = image
                        self.addBlurEffect()
                    }
                },
                failure: nil
            )
        }
        
        verifiedProfileButton.hidden = !userProfile.verified
    }

    func setOffice(office: OrganizationService.Containers.Address) {
        
        let officeName = office.hasName ? office.name : office.city
        let officeStateAndCountry = (office.hasRegion ? office.region : "") + ", " + office.country_code
        nameLabel.text = officeName
        nameNavLabel.text = officeName
        titleLabel.text = officeStateAndCountry
        titleNavLabel.text = officeStateAndCountry

        // TODO: - Remove hardcoded image
        profileImage.image = UIImage(named: "SF")
        backgroundImage.image = UIImage(named: "SF")
        addBlurEffect()
        verifiedProfileButton.hidden = true
    }

    // MARK: - Segmented Control

    private func configureSegmentedControl(sections withSections: [ProfileDetailView]) {
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
        sectionIndicatorView?.backgroundColor = UIColor.tabBarTintColor()
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
        animateSectionIndicator()
    }
    
    func updateSectionIndicatorView(contentOffset: CGPoint) {

        // We aren't animating the width of the sectionIndicator if someone taps on the segmented controls
        let currentSelectedButton = segmentedControlButtons[selectedButtonIndex()]
        var animationOffset = (currentSelectedButton.frameWidth / 2) + currentSelectedButton.frameX - (sectionIndicatorBeginningWidth / 2.0)
        if !sectionIndicatorViewIsAnimating {
            animationOffset = currentSelectedButton.frameX
        }
        sectionIndicatorLeftOffsetConstraint?.constant = (contentOffset.x / CGFloat(sections!.count)) + animationOffset
        animateSectionIndicator()
    }
    
    func finishMovingSelectionIndicatorView(contentOffset: CGPoint) {
        let buttonIndexToBeSelected = Int(contentOffset.x/frameWidth)
        if buttonIndexToBeSelected < segmentedControlButtons.count {
            sectionIndicatorWidthConstraint?.constant = segmentedControlButtons[buttonIndexToBeSelected].frameWidth
            sectionIndicatorLeftOffsetConstraint?.constant = contentOffset.x / CGFloat(sections!.count) + segmentedControlButtons[buttonIndexToBeSelected].frameX
            selectButtonAtIndex(buttonIndexToBeSelected)
        }
        animateSectionIndicator()
        sectionIndicatorViewIsAnimating = false
    }
    
    private func animateSectionIndicator() {
        UIView.animateWithDuration(
            0.3,
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

    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {

        // Check if the touch happened on any of the segmented control buttons
        // If not, let the super view handle the touch event
        for (index, button) in enumerate(segmentedControlButtons) {
            let pointRelativeToButton = button.convertPoint(point, fromView: self)
            if button.pointInside(pointRelativeToButton, withEvent: event) {
                tappedButton = button
                tappedButtonIndex = index
                return true
            }
        }

        return false
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
            insertSubview(visualEffectView!, aboveSubview: backgroundImage)
            visualEffectView!.autoSetDimensionsToSize(UIScreen.mainScreen().bounds.size)
            visualEffectView?.userInteractionEnabled = false
        }
    }
    
    func adjustViewForScrollContentOffset(contentOffset: CGPoint) {
        let minOffsetToMakeChanges: CGFloat = 20.0
        
        // Do not change anything unless user scrolls up more than 20 points
        if contentOffset.y > minOffsetToMakeChanges {
            
            // Scale down the image and reduce opacity
            let profileImageFractionValue = 1.0 - (contentOffset.y - minOffsetToMakeChanges)/profileImage.frameY
            profileImage.alpha = profileImageFractionValue
            if profileImageFractionValue >= 0 {
                var transform = CGAffineTransformMakeScale(profileImageFractionValue, profileImageFractionValue)
                profileImage.transform = transform
            }
            
            // Reduce opacity of the name and title label at a faster pace
            let titleLabelAlpha = 1.0 - contentOffset.y/(titleLabel.frameY - 40.0)
            let nameLabelAlpha = 1.0 - contentOffset.y/(nameLabel.frameY - 40.0)
            let sectionsAlpha = 1.0 - contentOffset.y/(sectionsView.frameY - 40.0)
            titleLabel.alpha = titleLabelAlpha
            verifiedProfileButton.alpha = nameLabelAlpha
            nameLabel.alpha = nameLabelAlpha
            nameNavLabel.alpha = sectionsAlpha <= 0.0 ? nameNavLabel.alpha + 1/20 : 0.0
            titleNavLabel.alpha = sectionsAlpha <= 0.0 ? titleNavLabel.alpha + 1/20 : 0.0
            sectionsView.alpha = sectionsAlpha
        }
        else {
            // Change alpha faster for profile image
            let profileImageAlpha = max(0.0, 1.0 - -contentOffset.y/80.0)
            
            // Change it slower for everything else
            let otherViewsAlpha = max(0.0, 1.0 - -contentOffset.y/120.0)
            nameLabel.alpha = otherViewsAlpha
            verifiedProfileButton.alpha = otherViewsAlpha
            nameNavLabel.alpha = 0.0
            titleNavLabel.alpha = 0.0
            titleLabel.alpha = otherViewsAlpha
            profileImage.alpha = profileImageAlpha
            visualEffectView?.alpha = otherViewsAlpha
            sectionsView.alpha = otherViewsAlpha
            profileImage.transform = CGAffineTransformIdentity
        }
    }
}
