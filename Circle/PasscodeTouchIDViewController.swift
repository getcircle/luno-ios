//
//  PasscodeTouchIDViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import VENTouchLock

class PasscodeTouchIDViewController: UIViewController {

    @IBOutlet weak private(set) var changePasscodeButton: UIButton!
    @IBOutlet weak private(set) var enableTouchIDLabel: UILabel!
    @IBOutlet weak private(set) var enableTouchIDInstructionLabel: UILabel!
    @IBOutlet weak private(set) var touchIDContainerView: UIView!
    @IBOutlet weak private(set) var touchIDSwitch: UISwitch!
    @IBOutlet weak private(set) var turnOffPasscodeButton: UIButton!
    
    private var firstLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Tracker.sharedInstance.trackPageView(pageType: .SettingsPasscodeTouchId)
        configureView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        configurePasscodeOptionButtons()
        configureTouchIDSwitch()
        configureEnableTouchIDLabel()
    }

    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
        title = NSLocalizedString("Passcode & Touch ID", comment: "Title of the view containing passcode and touch ID settings")
    }
    
    private func configureTouchIDSwitch() {
        touchIDSwitch.enabled = VENTouchLock.sharedInstance().isPasscodeSet() && VENTouchLock.canUseTouchID()
        touchIDSwitch.on = VENTouchLock.shouldUseTouchID()
    }
    
    private func configurePasscodeOptionButtons() {
        if firstLoad {
            firstLoad = false
            changePasscodeButton.addBottomBorder()
        }

        if VENTouchLock.sharedInstance().isPasscodeSet() {
            changePasscodeButton.setTitle(NSLocalizedString("Change Passcode", comment: "Title of the change passcode button"), forState: .Normal)
            turnOffPasscodeButton.enabled = true
        }
        else {
            changePasscodeButton.setTitle(NSLocalizedString("Set Passcode", comment: "Title of the set passcode button"), forState: .Normal)
            turnOffPasscodeButton.enabled = false
        }
    }
    
    private func configureEnableTouchIDLabel() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.enableTouchIDInstructionLabel.alpha = self.touchIDSwitch.enabled ? 0.0 : 1.0
            self.enableTouchIDLabel.alpha = self.touchIDSwitch.enabled ? 1.0 : 0.5
        })
    }
    
    // MARK: - Helpers

    private func showCreatePasscodeView(animated: Bool) {
        let createPasscodeViewController = VENTouchLockCreatePasscodeViewController()
        let navigationController = UINavigationController(rootViewController: createPasscodeViewController)
        presentViewController(navigationController, animated: animated, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func touchIDSwitchToggled(sender: UISwitch!) {
        VENTouchLock.setShouldUseTouchID(sender.on)
    }
    
    @IBAction func changePasscodeButtonTapped(sender: AnyObject!) {
        VENTouchLock.sharedInstance().deletePasscode()
        showCreatePasscodeView(true)
    }
    
    @IBAction func turnOffPasscodeButtonTapped(sender: AnyObject!) {
        if VENTouchLock.sharedInstance().isPasscodeSet() {
            VENTouchLock.sharedInstance().deletePasscode()
            configureTouchIDSwitch()
            configurePasscodeOptionButtons()
            configureEnableTouchIDLabel()
        }
    }
}
