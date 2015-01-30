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

class NewNoteViewController: UIViewController, UIViewControllerTransitioningDelegate, UITextViewDelegate {
    
    var delegate: NewNoteViewControllerDelegate?
    var note: NoteService.Containers.Note?
    var profile: ProfileService.Containers.Profile?

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var profileImageView: CircleImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileTitleLabel: UILabel!
    
    private var deleteAlertController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureNavigationBar()
        configureNavigationItems()
        configureDeleteAlertController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let profile = profile {
            profileImageView.setImageWithProfile(profile)
            profileNameLabel.text = profile.full_name
            profileTitleLabel.text = profile.title
        }
        if note == nil {
            noteTextView.becomeFirstResponder()
        }
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        profileImageView.makeItCircular(false)
        noteTextView.addTopBorder(offset: nil)
        noteTextView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        noteTextView.delegate = self
        if let note = note {
            noteTextView.text = note.content
        }
    }
    
    private func configureNavigationBar() {
        if let note = note {
            if let gmtDate = NSDateFormatter.dateFromTimestampString(note.changed) {
                navigationItem.title = NSDateFormatter.localizedRelativeDateString(gmtDate)
            }
        }
        else {
            navigationItem.title = NSLocalizedString("New Note", comment: "Title of the new note window")
        }
    }
    
    private func configureNavigationItems() {
        if isBeingPresentedModally() {
            let closeButton = UIBarButtonItem(
                image: UIImage(named: "Down"),
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
    
    // MARK: - IBActions
    
    @IBAction func closeButtonTapped(sender: AnyObject!) {
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
                image: UIImage(named: "CircleCheckFilled"),
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
                self.delegate?.didDeleteNote(self.note!)
                self.delegate?.didAddNote(note)
            }
            self.dismiss()
        }
    }
    
}
