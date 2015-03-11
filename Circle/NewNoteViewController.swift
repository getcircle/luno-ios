//
//  NewNoteViewController.swift
//  Circle
//
//  Created by Michael Hahn on 1/19/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

protocol NewNoteViewControllerDelegate {
    func didAddNote(note: NoteService.Containers.Note)
    func didDeleteNote(note: NoteService.Containers.Note)
}

class NewNoteViewController: UIViewController, UIViewControllerTransitioningDelegate, UITextViewDelegate, NSLayoutManagerDelegate {
    
    var delegate: NewNoteViewControllerDelegate?
    var note: NoteService.Containers.Note?
    var profile: ProfileService.Containers.Profile?

    @IBOutlet weak var deleteNoteButton: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var noteTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var newNoteButton: UIButton!
    @IBOutlet weak var profileImageView: CircleImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileTitleLabel: UILabel!
    
    private var deleteAlertController: UIAlertController!
    private var noteTopBorder: UIView!
    private var noteTextViewBottomConstraintInitialValue: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerNotifications()
        configureView()
        configureNavigationBar()
        configureNavigationItems()
        configureDeleteAlertController()
        configureNewNoteAndDeleteButton()
    }
    
    deinit {
        unregisterNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let profile = profile {
            if isPersonalNote() {
                noteTextViewTopConstraint.constant = -profileImageView.frameHeight
                noteTextView.setNeedsUpdateConstraints()
                noteTextView.layoutIfNeeded()
                noteTopBorder.hidden = true
                noteTopBorder.removeFromSuperview()
            }
            else {
                profileImageView.setImageWithProfile(profile)
                profileNameLabel.text = profile.full_name
                profileTitleLabel.text = profile.title
            }
        }
        
        if note == nil {
            noteTextView.becomeFirstResponder()
        }
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        profileImageView.makeItCircular()
        noteTopBorder = noteTextView.addTopBorder(offset: nil)
        noteTextView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        noteTextView.delegate = self
        noteTextView.layoutManager.delegate = self
        if let note = note {
            noteTextView.text = note.content
        }
        else {
            noteTextView.text = ""
            deleteNoteButton.removeFromSuperview()
            newNoteButton.removeFromSuperview()
        }
        
        
        noteTextViewBottomConstraintInitialValue = noteTextViewBottomConstraint.constant
    }
    
    private func configureNavigationBar() {
        if let note = note {
            if let gmtDate = NSDateFormatter.dateFromTimestampString(note.changed) {
                navigationItem.title = NSDateFormatter.stringFromDateWithStyles(
                    gmtDate,
                    dateStyle: .MediumStyle,
                    timeStyle: .ShortStyle
                )
            }
        }
        else {
            navigationItem.title = NSLocalizedString("New Note", comment: "Title of the new note window")
        }
    }
    
    private func configureNavigationItems() {
        if isBeingPresentedModally() {
            let closeButton = UIBarButtonItem(
                image: UIImage(named: "SmallClose"),
                style: .Plain,
                target: self,
                action: "closeButtonTapped:"
            )

            navigationItem.leftBarButtonItem = closeButton
        }
        
        if note == nil {
            addDoneButton()
        }
    }
    
    private func configureDeleteAlertController() {
        deleteAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(
                title: NSLocalizedString("Delete", comment: "Generic button title for deleting an item"),
                style: .Destructive
            ) { (action) -> Void in
                NoteService.Actions.deleteNote(self.note!, completionHandler: { (error) -> Void in
                    if error == nil {
                        self.trackDeleteNoteAction(self.note!)
                        self.delegate?.didDeleteNote(self.note!)
                        self.dismiss()
                    }
                }
            )
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: "Generic button title for cancelling an operation"),
            style: .Cancel,
            handler: nil
        )
        deleteAlertController.addAction(deleteAction)
        deleteAlertController.addAction(cancelAction)
    }
    
    private func configureNewNoteAndDeleteButton() {
        for button in [newNoteButton, deleteNoteButton] {
            button.convertToTemplateImageForState(.Normal)
            button.tintColor = UIColor.appQuickActionsTintColor()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButtonTapped(sender: AnyObject!) {
        trackDismissNote()
        dismiss()
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject!) {
        if note != nil {
            updateNote()
        } else {
            saveNewNote()
        }
    }
    
    @IBAction func titleOverlayButtonTapped(sender: AnyObject) {
        if note != nil {
            noteTextView.resignFirstResponder()
        }
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        presentViewController(deleteAlertController, animated: true, completion: nil)
    }
    
    @IBAction func newButtonTapped(sender: AnyObject) {
        trackNewNoteAction()
        noteTextView.resignFirstResponder()
        let newNoteViewController = NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
        newNoteViewController.profile = profile
        newNoteViewController.delegate = delegate
        var viewControllers = navigationController!.viewControllers
        if isBeingPresentedModally() {
            viewControllers = [newNoteViewController]
        }
        else {
            viewControllers[viewControllers.count - 1] = newNoteViewController
        }
        
        navigationController?.setViewControllers(viewControllers, animated: false)        
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if note != nil {
            addDoneButton()
        }
    }

    // MARK: - Helpers
    
    private func dismiss() {
        noteTextView.resignFirstResponder()
        if isBeingPresentedModally() {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func addDoneButton() {
        if navigationItem.rightBarButtonItems == nil {
            let doneButton = UIBarButtonItem(
                image: UIImage(named: "Check"),
                style: .Plain,
                target: self,
                action: "doneButtonTapped:"
            )
            navigationItem.setRightBarButtonItem(doneButton, animated: true)
        }
    }
    
    private func saveNewNote() {
        let currentProfile = AuthViewController.getLoggedInUserProfile()!
        let noteBuilder = NoteService.Containers.Note.builder()
        noteBuilder.for_profile_id = profile!.id
        noteBuilder.owner_profile_id = currentProfile.id
        noteBuilder.content = noteTextView.text
        NoteService.Actions.createNote(noteBuilder.build()) { (note, error) -> Void in
            if let note = note {
                self.trackSaveNoteAction(note)
                self.delegate?.didAddNote(note)
            }
            self.dismiss()
        }
    }
    
    private func updateNote() {
        let noteBuilder = note!.toBuilder()
        noteBuilder.content = noteTextView.text
        NoteService.Actions.updateNote(noteBuilder.build()) { (note, error) -> Void in
            if let note = note {
                self.trackUpdateNoteAction(note)
                self.delegate?.didDeleteNote(self.note!)
                self.delegate?.didAddNote(note)
            }
            self.dismiss()
        }
    }
    
    private func isPersonalNote() -> Bool {
        if let profile = profile {
            if profile.id == AuthViewController.getLoggedInUserProfile()!.id {
                return true
            }
        }
        return false
    }
    
    // MARK: - NSLayoutManagerDelegate
    
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 4.0
    }
    
    // MARK: - Notifications
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, 
            selector: "keyboardWasShown:",
            name: UIKeyboardDidShowNotification, 
            object: nil
        )

        NSNotificationCenter.defaultCenter().addObserver(
            self, 
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification, 
            object: nil
        )
    }
    
    func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let keyboardSizeValue: NSValue = userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            noteTextViewBottomConstraint.constant = keyboardSizeValue.CGRectValue().size.height
            noteTextView.setNeedsUpdateConstraints()
            noteTextView.layoutIfNeeded()
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        noteTextViewBottomConstraint.constant = noteTextViewBottomConstraintInitialValue
        noteTextView.setNeedsUpdateConstraints()
        noteTextView.layoutIfNeeded()
    }
    
    // MARK: - Tracking
    
    private func trackNewNoteAction() {
        var properties = [
            TrackerProperty.withKeyString("personal_note").withValue(isPersonalNote()),
            TrackerProperty.withKey(.Source).withSource(.Detail),
            TrackerProperty.withKey(.SourceDetailType).withDetailType(.Note)
        ]
        if let profile = profile {
            properties.append(TrackerProperty.withDestinationId("profile_id").withString(profile.id))
        }
        Tracker.sharedInstance.track(.NewNote, properties: properties)
    }
    
    private func trackSaveNoteAction(note: NoteService.Containers.Note) {
        let properties = propertiesForNoteTracking(note)
        Tracker.sharedInstance.track(.SaveNote, properties: properties)
    }
    
    private func trackDeleteNoteAction(note: NoteService.Containers.Note) {
        let properties = propertiesForNoteTracking(note)
        Tracker.sharedInstance.track(.DeleteNote, properties: properties)
    }
    
    private func trackUpdateNoteAction(note: NoteService.Containers.Note) {
        let properties = propertiesForNoteTracking(note)
        Tracker.sharedInstance.track(.UpdateNote, properties: properties)
    }
    
    private func trackDismissNote() {
        let properties = [
            TrackerProperty.withKeyString("personal_note").withValue(isPersonalNote()),
            TrackerProperty.withKey(.Source).withSource(.Detail),
            TrackerProperty.withKey(.SourceDetailType).withDetailType(.Note),
            TrackerProperty.withKeyString("has_been_saved").withValue(note != nil)
        ]
        Tracker.sharedInstance.track(.DismissNote, properties: properties)
    }
    
    private func propertiesForNoteTracking(note: NoteService.Containers.Note) -> [TrackerProperty] {
        var properties = [
            TrackerProperty.withKeyString("note_id").withString(note.id),
            TrackerProperty.withKeyString("personal_note").withValue(isPersonalNote()),
        ]
        if let profile = profile {
            properties.append(TrackerProperty.withKeyString("for_profile_id").withString(profile.id))
        }
        return properties
    }
}
