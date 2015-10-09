//
//  TextInputViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry
import MBProgressHUD

protocol TextInputViewControllerDelegate {
    func onTextInputValueUpdated(updatedObject: AnyObject?)
}

class TextInputViewController: UIViewController, UITextViewDelegate {
    
    enum Themes {
        case Onboarding
        case Regular
    }
    
    var addPostButton: Bool = false
    var theme: Themes = .Regular
    
    @IBOutlet weak private(set) var characterLimitLabel: UILabel!
    @IBOutlet weak private(set) var controlsContainer: UIView!
    @IBOutlet weak private(set) var controlsContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var placeholderLabel: UILabel!
    @IBOutlet weak private(set) var textView: UITextView!

    internal let characterLimit = 144
    
    private var allControls = [AnyObject]()
    private var addCharacterLimit: Bool
    private var hud: MBProgressHUD?
    private var delegate: TextInputViewControllerDelegate?

    init(addCharacterLimit: Bool, withDelegate: TextInputViewControllerDelegate? = nil) {
        self.addCharacterLimit = addCharacterLimit
        self.delegate = withDelegate
        super.init(nibName: "TextInputViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        addCharacterLimit = true
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assertRequiredData()
        registerNotifications()
        configureView()
        configureNavigationBar()
        configureTextFields()
        configurePlaceholderLabel()
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
        title = getViewTitle()
        
        if addPostButton {
            addPostTextButtonWithAction("done:")
        }
        else {
            addDoneButtonWithAction("done:")
        }
        
        if isBeingPresentedModally() {
            addCancelTextButtonWithAction("cancel:")
        }
    }
    
    private func configureTextFields() {
        allControls.append(textView)
        textView.text = ""
        
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
    
    private func configurePlaceholderLabel() {
        placeholderLabel.text = getTextPlaceholder()
    }
    
    private func populateData() {
        if let data = getData() where data.trimWhitespace() != "" {
            textView.text = data
            placeholderLabel.hidden = true
        }
        else {
            placeholderLabel.hidden = false
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
        let data = textView.text.trimWhitespace()
        if data.characters.count > characterLimit && addCharacterLimit {
            return
        }
        
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        do {
            try saveData(data)
        }
        catch {
            print("Error: \(error)")
            
            if let hud = self.hud {
                hud.hide(true)
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
        placeholderLabel.hidden = !(self.textView.text.characters.count == 0)
    }

    // MARK: - Helpers
    
    private func updateCharacterLimit() {
        let numberOfCharactersLeft = characterLimit - textView.text.characters.count
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
    
    internal func assertRequiredData() {
        fatalError("Must be implemented by subclasses")
    }
    
    internal func getViewTitle() -> String {
        fatalError("Must be implemented by subclasses")
    }
    
    internal func getTextPlaceholder() -> String {
        fatalError("Must be implemented by subclasses")
    }
    
    internal func getData() -> String? {
        fatalError("Must be implemented by subclasses")
    }

    internal func saveData(data: String) throws {
        fatalError("Must be implemented by subclasses")
    }
    
    
    final internal func onDataSaved(updatedObject: AnyObject?) {
        if let hud = self.hud {
            hud.hide(true)
        }
        
        delegate?.onTextInputValueUpdated(updatedObject)
        if addPostButton {
            goToNextVC()
        }
        else {
            dismissView()
        }
    }
    
    // MARK: - IBActions
    
    private func goToNextVC() {
        let notificationsVC = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
}
