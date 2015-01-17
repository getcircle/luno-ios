//
//  CircleAlertViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/16/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class CircleAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak private(set) var actionButton: UIButton!
    @IBOutlet weak private(set) var parentContainerView: UIView!
    @IBOutlet weak private(set) var textLabel: UILabel!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureView()
    }

    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.clearColor()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let blurEffect = UIBlurEffect(style: .Dark)
        var visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(visualEffectView)
        view.sendSubviewToBack(visualEffectView)
        visualEffectView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleAlertViewAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleAlertViewAnimator()
    }
    
    // MARK: - IBActions
    
    @IBAction func viewTapped(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
