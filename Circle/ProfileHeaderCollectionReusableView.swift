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

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameNavLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: CircleImageView!
    @IBOutlet weak var sectionsView: UIView!
    @IBOutlet weak var verifiedProfileButton: UIButton!
    
    var profileSegmentedControlDelegate: ProfileDetailSegmentedControlDelegate?
    var sections: [ProfileDetailView]? {
        didSet {
            if sections != nil {
                configureSegmentedControl(sections: sections!)
            }
        }
    }
    var tappedButtonInSegmentedControl: UIButton?
    var tappedButtonInSegmentedControlIndex: Int?
    private(set) var visualEffectView: UIVisualEffectView!
    
    private var sectionIndicatorView: UIView?
    private var sectionIndicatorLeftOffsetConstraint: NSLayoutConstraint?
    private var sectionIndicatorWidthConstraint: NSLayoutConstraint?
    private var sectionIndicatorViewIsAnimating = false
    private var segmentedControlButtons = [UIButton]()
    private var buttonSize = CGSizeZero
    
    override class var classReuseIdentifier: String {
        return "ProfileHeaderView"
    }
    
    override class var height: CGFloat {
        return 240.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        let blurEffect = UIBlurEffect(style: .Dark)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        visualEffectView.frame = backgroundImage.frame
        insertSubview(visualEffectView, aboveSubview: backgroundImage)
        visualEffectView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        profileImage.makeItCircular(true)
        nameNavLabel.alpha = 0.0
        sectionsView.backgroundColor = UIColor.viewBackgroundColor()
    }
    
    func setProfile(profile: ProfileService.Containers.Profile) {
        nameLabel.text = profile.first_name + " " + profile.last_name
        nameNavLabel.text = nameLabel.text
        titleLabel.text = profile.title
        profileImage.setImageWithProfile(profile)
        backgroundImage.setImageWithURL(
            NSURL(string: profile.image_url)
        )
        verifiedProfileButton.hidden = !profile.verified
    }
    
    // MARK: - Segmented Control

    private func configureSegmentedControl(sections withSections: [ProfileDetailView]) {
        // Setup the segment buttons
        let buttonSegmentOffset: CGFloat = 0.5
        let buttonSegmentHeight: CGFloat = 39.0
        let width: CGFloat = (frame.width - (CGFloat(withSections.count - 1) * buttonSegmentOffset)) / CGFloat(withSections.count)
        buttonSize = CGSizeMake(width, buttonSegmentHeight)
        
        var previousButton: UIButton?
        for section in withSections {
            let button = UIButton.buttonWithType(.System) as UIButton
            button.setTitle(section.title, forState: .Normal)
//          This is still needed but commenting it out until we have better icons
//            if let imageSrc = section.image {
//                if imageSrc != "" {
//                    button.setImage(UIImage(named: imageSrc), forState: .Normal)
//                    button.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
//                }
//            }
            button.tintColor = UIColor.appTintColor()
            button.addTarget(self, action: "segmentButtonPressed:", forControlEvents: .TouchUpInside)
            button.autoSetDimensionsToSize(buttonSize)
            button.titleLabel?.font = UIFont.segmentedControlTitleFont()
            button.backgroundColor = UIColor.whiteColor()
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
        
        sectionIndicatorView?.backgroundColor = UIColor.appTintColor()
        sectionIndicatorView?.autoSetDimension(.Height, toSize: 1.5)
        sectionIndicatorWidthConstraint = sectionIndicatorView?.autoSetDimension(.Width, toSize: buttonSize.width)
        sectionIndicatorView?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: sectionsView)
        sectionIndicatorLeftOffsetConstraint = sectionIndicatorView?.autoPinEdge(.Left, toEdge: .Left, ofView: sectionsView)
    }
    
    func segmentButtonPressed(sender: AnyObject!) {
        if let tappedButtonIndex = tappedButtonInSegmentedControlIndex {
            profileSegmentedControlDelegate?.onButtonTouchUpInsideAtIndex(tappedButtonIndex)
        }
    }
    
    func updateTitle(title: String, forSegmentAtIndex index: Int) {
        if segmentedControlButtons.count > index {
            segmentedControlButtons[index].setTitle(title, forState: .Normal)
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
                tappedButtonInSegmentedControl = button
                tappedButtonInSegmentedControlIndex = index
                return true
            }
        }
        
        return false
    }
}
