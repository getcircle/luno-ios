//
//  CircleAlertViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/16/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

protocol CircleAlertViewDelegate {
    func alertActionButtonPressed(sender: AnyObject!)
}

class CircleAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {

    private var actionButton: UIButton!
    private(set) var parentContainerView: UIView!
    private(set) var parentContainerViewCenterYConstraint: NSLayoutConstraint!
    private var textLabel: UILabel!
    private var titleLabel: UILabel!
    
    var addCancelButton = false
    var cancelButton: UIButton?
    var circleAlertViewDelegate: CircleAlertViewDelegate?
    var shouldBlurBackground = true
    
    private(set) var visualEffectView: UIView!
    
    final override func loadView() {
        var rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.opaque = true
        view = rootView
        
        parentContainerView = UIView(forAutoLayout: ())
        view.addSubview(parentContainerView)
        parentContainerView.backgroundColor = UIColor.whiteColor()
        parentContainerView.opaque = true
        parentContainerView.addRoundCorners(radius: 5.0)
        parentContainerView.autoAlignAxisToSuperviewAxis(.Vertical)
        parentContainerViewCenterYConstraint = parentContainerView.autoAlignAxisToSuperviewAxis(.Horizontal)
        parentContainerView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
        parentContainerView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureView()
        configureModalParentView()
        configureCancelButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let cancelButton = cancelButton {
            cancelButton.alpha = 0.0
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let cancelButton = cancelButton {
            cancelButton.alpha = 1.0
        }
    }

    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.clearColor()
        if shouldBlurBackground {
            visualEffectView = view.addVisualEffectView(.Dark) as UIView
        }
        else {
            visualEffectView = UIView(forAutoLayout: ())
            visualEffectView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            view.insertSubview(visualEffectView, belowSubview: parentContainerView)
            visualEffectView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
        visualEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func configureModalParentView() {
        titleLabel = UILabel(forAutoLayout: ())
        titleLabel.opaque = true
        titleLabel.backgroundColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.text = NSLocalizedString(
            "Welcome to Circle",
            comment: "Title label for welcoming users to the app"
        )
        titleLabel.textColor = UIColor.defaultDarkTextColor()
        titleLabel.font = UIFont.appOnboardingModalTitle()
        parentContainerView.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(
            UIEdgeInsetsMake(20.0, 10.0, 0.0, 10.0),
            excludingEdge: .Bottom
        )
        
        textLabel = UILabel(forAutoLayout: ())
        textLabel.opaque = true
        textLabel.backgroundColor = UIColor.whiteColor()
        textLabel.textAlignment = .Center
        textLabel.text = NSLocalizedString(
            "Lets get started by verifying your phone number and setting up your profile.", 
            comment: "Text to indicate users the next steps of phone number verification and profile setup.")
        textLabel.textColor = UIColor.defaultDarkTextColor()
        textLabel.font = UIFont.appOnboardingModalText()
        textLabel.numberOfLines = 0
        parentContainerView.addSubview(textLabel)
        textLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
        textLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
        textLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 30.0)
        
        actionButton = UIButton(forAutoLayout: ())
        actionButton.setTitle(
            NSLocalizedString(
                "Get Started!",
                comment: "Title of the button prompting user to get started with the setup"
            ),
            forState: .Normal
        )
        actionButton.tintColor = UIColor.appTintColor()
        actionButton.setTitleColor(UIColor.appTintColor(), forState: .Normal)
        actionButton.titleLabel!.font = UIFont.appOnboardingModalCTA()
        actionButton.showsTouchWhenHighlighted = true
        actionButton.addTarget(self, action: "viewTapped:", forControlEvents: .TouchUpInside)
        parentContainerView.addSubview(actionButton)
        
        actionButton.autoSetDimension(.Height, toSize: 44.0)
        actionButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20.0)
        actionButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: textLabel, withOffset: 30.0)
        actionButton.autoAlignAxisToSuperviewAxis(.Vertical)
    }
    
    private func configureCancelButton() {
        if !addCancelButton {
            return
        }

        cancelButton = UIButton(forAutoLayout: ())
        if let cancelButton = cancelButton {
            cancelButton.setImage(UIImage(named: "Close"), forState: .Normal)
            cancelButton.convertToTemplateImageForState(.Normal)
            cancelButton.tintColor = UIColor.whiteColor()
            cancelButton.showsTouchWhenHighlighted = true
            cancelButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            cancelButton.addTarget(self, action: "viewTapped:", forControlEvents: .TouchUpInside)
            view.addSubview(cancelButton)
            view.bringSubviewToFront(cancelButton)

            cancelButton.autoAlignAxisToSuperviewAxis(.Vertical)
            cancelButton.autoSetDimensionsToSize(CGSizeMake(36.0, 36.0))
            cancelButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)
            cancelButton.addRoundCorners(radius: 18.0)
            cancelButton.layer.borderColor = UIColor.whiteColor().CGColor
            cancelButton.layer.borderWidth = 1.0
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleAlertViewAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleAlertViewAnimator()
    }
    
    // MARK: - IBActions
    
    @IBAction func viewTapped(sender: AnyObject!) {
        circleAlertViewDelegate?.alertActionButtonPressed(sender)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
