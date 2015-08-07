//
//  EditAboutViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry
import MBProgressHUD

class EditAboutViewController: UIViewController, UITextViewDelegate {

    enum Themes {
        case Onboarding
        case Regular
    }

    var addNextButton: Bool = false
    var profile: Services.Profile.Containers.ProfileV1!
    var theme: Themes = .Regular
    
    @IBOutlet weak private(set) var characterLimitLabel: UILabel!
    @IBOutlet weak private(set) var controlsContainer: UIView!
    @IBOutlet weak private(set) var controlsContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var placeholderLabel: UILabel!
    @IBOutlet weak private(set) var textView: UITextView!

    private var allControls = [AnyObject]()
    private var addCharacterLimit: Bool
    private let characterLimit = 144

    init(addCharacterLimit: Bool) {
        self.addCharacterLimit = addCharacterLimit
        super.init(nibName: "EditAboutViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        addCharacterLimit = true
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assert(profile != nil, "Profile should be set for this view controller")
        registerNotifications()
        configureView()
        configureNavigationBar()
        configureTextFields()
        configureCharacterLimitLabel()
        populateData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    deinit {
        unregisterNotifications()
    }
    
    // MARK: - Configuration

    private func configureView() {
        switch theme {
        case .Regular:
            view.backgroundColor = UIColor.appViewBackgroundColor()

        case .Onboarding:
            view.backgroundColor = UIColor.appUIBackgroundColor()
        }
        
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func configureNavigationBar() {
        title = AppStrings.ProfileSectionStatusTitle
        if addNextButton {
            addNextButtonWithAction("done:")
        }
        else {
            addDoneButtonWithAction("done:")
        }
        
        if isBeingPresentedModally() {
            addCloseButtonWithAction("cancel:")
        }
    }
    
    private func configureTextFields() {
        allControls.append(textView)
        
        switch theme {
        case .Regular:
            textView.keyboardAppearance = .Light
            
        case .Onboarding:
            textView.keyboardAppearance = .Dark
        }
    }
    
    private func configureCharacterLimitLabel() {
        if addCharacterLimit {
            characterLimitLabel.text = String(characterLimit)
        }
        else {
            characterLimitLabel.hidden = true
        }
    }
    
    private func populateData() {
        if profile.hasStatus {
            textView.text = profile.status.value
            placeholderLabel.hidden = true
        }
    }
    
    // MARK: - Notifications
    
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, 
            selector: "keyboardWillShow:", 
            name: UIKeyboardWillShowNotification, 
            object: nil
        )

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo, rect: NSValue = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = rect.CGRectValue().size.height
            let animationDuration: Double = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3
            moveControlsContainer(height, animationSpeed: animationDuration)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let info = notification.userInfo {
            let animationDuration: Double = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3
            moveControlsContainer(0, animationSpeed: animationDuration)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func done(sender: AnyObject!) {
        updateProfile { () -> Void in
            if self.addNextButton {
                self.goToNextVC()
            }
            else {
                self.dismissView()
            }
        }
    }

    @IBAction func cancel(sender: AnyObject!) {
        dismissView()
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        updateCharacterLimit()
    }
    
    func textViewDidChange(textView: UITextView) {
        updateCharacterLimit()
        placeholderLabel.hidden = !(count(self.textView.text) == 0)
    }

    // MARK: - Helpers
    
    private func updateCharacterLimit() {
        let numberOfCharactersLeft = characterLimit - count(textView.text)
        characterLimitLabel.text = String(numberOfCharactersLeft)
        if numberOfCharactersLeft < 0 {
            characterLimitLabel.textColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        }
        else {
            characterLimitLabel.textColor = UIColor(red: 160, green: 160, blue: 160)
        }
    }
    
    private func moveControlsContainer(bottomConstraint: CGFloat, animationSpeed: NSTimeInterval) {
        controlsContainerBottomConstraint.constant = bottomConstraint
        controlsContainer.setNeedsUpdateConstraints()
        UIView.animateWithDuration(animationSpeed, animations: { () -> Void in
            self.controlsContainer.layoutIfNeeded()
            self.textView.layoutIfNeeded()
            self.characterLimitLabel.layoutIfNeeded()
        })
    }
    
    private func dismissView() {
        dismissKeyboard()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func dismissKeyboard() {
        for control in allControls {
            if control.isFirstResponder() {
                control.resignFirstResponder()
                break
            }
        }
    }
    
    private func updateProfile(completion: () -> Void) {
        let statusBuilder: Services.Profile.Containers.ProfileStatusV1Builder
        if let status = profile.status {
            statusBuilder = status.toBuilder()
        }
        else {
            statusBuilder = Services.Profile.Containers.ProfileStatusV1Builder()
        }
        
        let profileBuilder = profile.toBuilder()
        let statusText = textView.text.trimWhitespace()
        if count(statusText) > characterLimit {
            return
        }
        if statusText != "" {
            statusBuilder.value = statusText
        }
        
        profileBuilder.status = statusBuilder.build()
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        Services.Profile.Actions.updateProfile(profileBuilder.build()) { (profile, error) -> Void in
            if let profile = profile {
                AuthViewController.updateUserProfile(profile)
            }
            hud.hide(true)
            completion()
        }
    }
    
    // MARK: - IBActions
    
    private func goToNextVC() {
        let notificationsVC = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
}
