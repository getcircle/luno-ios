//
//  SplashViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import VENTouchLock

class SplashViewController: VENTouchLockSplashViewController {

    @IBOutlet weak private(set) var touchIDButton: UIButton!
    @IBOutlet weak private(set) var touchIDButtonLabel: UILabel!
    @IBOutlet weak private(set) var passcodeButton: UIButton!
    @IBOutlet weak private(set) var passcodeButtonLabel: UILabel!
    @IBOutlet weak private(set) var passcodeButtonXConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var signInToDifferentAccountButton: UIButton!
    
    init() {
        super.init(nibName: "SplashViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func customInit() {
        view.backgroundColor = UIColor.appUIBackgroundColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureResponseCallback()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureButtons()
    }

    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
    }
    
    private func configureResponseCallback() {
        didFinishWithSuccess = {(success: Bool, unlockType: VENTouchLockSplashViewControllerUnlockType) in
            
            if success {
                // TODO: - Add mixpanel logging
                switch unlockType {
                case .TouchID:
                    break
                    
                case .Passcode:
                    break
                    
                default:
                    break
                }
            }
            else {
                // TODO: - Handle limit exceeded
            }
        }
    }
    
    private func configureButtons() {
        touchIDButton.hidden = !VENTouchLock.shouldUseTouchID()
        if touchIDButton.hidden {
            passcodeButtonXConstraint.constant = 0.0
            touchIDButtonLabel.alpha = 0.0
        }
        else {
            passcodeButtonXConstraint.constant = -100.0
            touchIDButtonLabel.alpha = 1.0
        }

        touchIDButton.makeItCircular(true, borderColor: UIColor.appUIBackgroundColor())
        passcodeButton.makeItCircular(true, borderColor: UIColor.appUIBackgroundColor())
    }
    
    // MARK: - IBActions
    
    @IBAction func passcodeButtonTapped(sender: AnyObject!) {
        showPasscodeAnimated(true)
    }
    
    @IBAction func touchIDButtonTapped(sender: AnyObject!) {
        showTouchID()
    }
    
    @IBAction func signIntoDifferentAccountButtonTapped(sender: AnyObject!) {
        if VENTouchLock.sharedInstance().isPasscodeSet() {
            VENTouchLock.sharedInstance().deletePasscode()
        }
        
        dismissViewControllerAnimated(false, completion: { () -> Void in
            AuthViewController.logOut()
        })
    }
}
