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

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameNavLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: CircleImageView!
    @IBOutlet weak var sectionsView: UIView!
    
    var sections: [String]? {
        didSet {
            if sections != nil {
                configureSegmentedControl(sections: sections!)
            }
        }
    }
    var tappedButtonInSegmentedControl: UIButton?
    private(set) var visualEffectView: UIVisualEffectView!

    private var sectionIndicatorView: UIView?
    private var sectionIndicatorLeftOffset: NSLayoutConstraint?
    private var segmentedControlButtons = [UIButton]()
    
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
    }
    
    private func configureSegmentedControl(sections withSections: [String]) {
        // Setup the segment buttons
        let buttonSegmentOffset: CGFloat = 0.5
        let buttonSegmentHeight: CGFloat = 40.0
        let width: CGFloat = (frame.width - (CGFloat(withSections.count - 1) * buttonSegmentOffset)) / CGFloat(withSections.count)
        let buttonSize = CGSizeMake(width, buttonSegmentHeight)
        
        var previousButton: UIButton?
        for section in withSections {
            let button = UIButton.buttonWithType(.System) as UIButton
            button.setTitle(section, forState: .Normal)
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
        sectionIndicatorView?.autoSetDimensionsToSize(CGSizeMake(buttonSize.width, 5.0))
        sectionIndicatorView?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: sectionsView)
        sectionIndicatorLeftOffset = sectionIndicatorView?.autoPinEdge(.Left, toEdge: .Left, ofView: sectionsView)
    }
    
    func segmentButtonPressed(sender: AnyObject!) {
        println("segment button pressed")
    }
    
    func updateSectionIndicatorView(contentOffset: CGPoint) {
        sectionIndicatorLeftOffset?.constant = contentOffset.x / CGFloat(sections!.count)
    }

    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {

        // Check if the touch happened on any of the segmented control buttons
        // If not, let the super view handle the touch event
        for button in segmentedControlButtons {
            let pointRelativeToButton = button.convertPoint(point, fromView: self)
            if button.pointInside(pointRelativeToButton, withEvent: event) {
                tappedButtonInSegmentedControl = button
                return true
            }
        }
        
        return false
    }
}
