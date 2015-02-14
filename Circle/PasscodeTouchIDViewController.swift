//
//  PasscodeTouchIDViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class PasscodeTouchIDViewController: UIViewController {

    @IBOutlet weak private(set) var changePasscodeButton: UIButton!
    @IBOutlet weak private(set) var enableTouchIDLabel: UILabel!
    @IBOutlet weak private(set) var touchIDContainerView: UIView!
    @IBOutlet weak private(set) var touchIDSwitch: UISwitch!
    @IBOutlet weak private(set) var turnOffPasscodeButton: UIButton!
    
    private var firstLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        view.backgroundColor = UIColor.viewBackgroundColor()
        title = NSLocalizedString("Passcode & Touch ID", comment: "Title of the view containing passcode and touch ID settings")
    }
    
    private func configureTouchIDSwitch() {
        touchIDSwitch.enabled = VENTouchLock.sharedInstance().isPasscodeSet() && VENTouchLock.canUseTouchID()
        touchIDSwitch.on = VENTouchLock.shouldUseTouchID()
    }
    
    private func configurePasscodeOptionButtons() {
        if firstLoad {
            firstLoad = false
            changePasscodeButton.addBottomBorder(offset: 0.0)
        }

        if VENTouchLock.sharedInstance().isPasscodeSet() {
            changePasscodeButton.setTitle(NSLocalizedString("Change Passcode", comment: "Title of the change passcode button"), forState: .Normal)
            turnOffPasscodeButton.enabled = true
        }
        else {
            changePasscodeButton.setTitle(NSLocalizedString("Set Passcode", comment: "Title of the set passcode button"), forState: .Normal)
            turnOffPasscodeButton.enabled = true
        }
    }
    
    private func configureEnableTouchIDLabel() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.enableTouchIDLabel.alpha = self.touchIDSwitch.enabled ? 0.0 : 1.0
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
