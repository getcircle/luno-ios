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
    
    private var buttonSize = CGSizeZero
    private var profile: ProfileService.Containers.Profile?
    private var sectionIndicatorView: UIView?
    private var sectionIndicatorLeftOffsetConstraint: NSLayoutConstraint?
    private var sectionIndicatorWidthConstraint: NSLayoutConstraint?
    private var sectionIndicatorViewIsAnimating = false
    private var segmentedControlButtons = [UIButton]()
    
    override class var classReuseIdentifier: String {
        return "ProfileHeaderView"
    }
    
    override class var height: CGFloat {
        return 270.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        profileImage.makeItCircular(true, borderColor: UIColor.whiteColor())
        nameNavLabel.alpha = 0.0
    }
    
    func setProfile(userProfile: ProfileService.Containers.Profile) {
        profile = userProfile
        nameLabel.text = userProfile.first_name + " " + userProfile.last_name
        nameNavLabel.text = nameLabel.text
        titleLabel.text = userProfile.title
        profileImage.setImageWithProfile(userProfile)
        
        if let imageURL = NSURL(string: userProfile.image_url) {
            let urlImageRequest = NSURLRequest(URL: imageURL)
            backgroundImage.setImageWithURLRequest(
                urlImageRequest,
                placeholderImage: UIImage.imageFromColor(UIColor.darkGrayColor(), withRect: bounds),
                success: { (request, response, image) -> Void in
                    if self.backgroundImage.image != image {
                        self.backgroundImage.image = image
                        
                        let blurEffect = UIBlurEffect(style: .Dark)
                        self.visualEffectView = UIVisualEffectView(effect: blurEffect)
                        self.visualEffectView!.setTranslatesAutoresizingMaskIntoConstraints(false)
                        self.visualEffectView!.frame = self.backgroundImage.frame
                        self.insertSubview(self.visualEffectView!, aboveSubview: self.backgroundImage)
                        self.visualEffectView!.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
                    }
                },
                failure: nil
            )
        }
        
        verifiedProfileButton.hidden = !userProfile.verified
    }
    
    // MARK: - Segmented Control

    private func configureSegmentedControl(sections withSections: [ProfileDetailView]) {
        // Setup the segment buttons
        let buttonSegmentOffset: CGFloat = 0.5
        let buttonSegmentHeight: CGFloat = 34.0
        let width: CGFloat = (frame.width - (CGFloat(withSections.count - 1) * buttonSegmentOffset)) / CGFloat(withSections.count)
        buttonSize = CGSizeMake(width, buttonSegmentHeight)
        
        var previousButton: UIButton?
        for section in withSections {
            let button = UIButton.buttonWithType(.System) as UIButton
            button.setTitle(section.title.uppercaseString, forState: .Normal)
            button.tintColor = UIColor.whiteColor()
            button.addTarget(
                self,
                action: "segmentButtonPressed:", 
                forControlEvents: .TouchUpInside
            )
            button.autoSetDimensionsToSize(buttonSize)
            button.titleLabel?.font = UIFont.segmentedControlTitleFont()
            sectionsView.addSubview(button)
            if let previous = previousButton {
                button.autoPinEdge(.Left, toEdge: .Right, ofView: previous, withOffset: buttonSegmentOffset)
            } else {
                button.autoPinEdge(.Left, toEdge: .Left, ofView: sectionsView)
            }
            button.autoPinEdge(.Top, toEdge: .Top, ofView: sectionsView)
            previousButton = button
            segmentedControlButtons.append(button)
        }
        
        // Setup the section indicator view
        sectionIndicatorView = UIView.newAutoLayoutView()
        sectionsView.addSubview(sectionIndicatorView!)
        
        sectionIndicatorView?.backgroundColor = UIColor.tabBarTintColor()
        sectionIndicatorView?.autoSetDimension(.Height, toSize: 1.5)
        sectionIndicatorWidthConstraint = sectionIndicatorView?.autoSetDimension(.Width, toSize: buttonSize.width)
        sectionIndicatorView?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: sectionsView)
        sectionIndicatorLeftOffsetConstraint = sectionIndicatorView?.autoPinEdge(.Left, toEdge: .Left, ofView: sectionsView)
    }
    
    func segmentButtonPressed(sender: AnyObject!) {
        if let tappedButtonIndex = tappedButtonIndex {
            profileSegmentedControlDelegate?.onButtonTouchUpInsideAtIndex(tappedButtonIndex)
        }
    }
    
    func updateTitle(title: String, forSegmentAtIndex index: Int) {
        if segmentedControlButtons.count > index {
            segmentedControlButtons[index].setTitle(title.uppercaseString, forState: .Normal)
        }
    }
    
    func beginMovingSectionIndicatorView(contentOffset: CGPoint) {
        sectionIndicatorViewIsAnimating = true
        sectionIndicatorWidthConstraint?.constant = 50
        animateSectionIndicator()
    }
    
    func updateSectionIndicatorView(contentOffset: CGPoint) {
        // We aren't animating the width of the sectionIndicator if someone taps on the segmented controls
        var animationOffset = buttonSize.width / 2
        if !sectionIndicatorViewIsAnimating {
            animationOffset = 0.0
        }
        sectionIndicatorLeftOffsetConstraint?.constant = (contentOffset.x / CGFloat(sections!.count)) + animationOffset
        animateSectionIndicator()
    }
    
    func finishMovingSelectionIndicatorView(contentOffset: CGPoint) {
        sectionIndicatorWidthConstraint?.constant = buttonSize.width
        sectionIndicatorLeftOffsetConstraint?.constant = contentOffset.x / CGFloat(sections!.count)
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
}
