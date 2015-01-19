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
}

class NewNoteViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var delegate: NewNoteViewControllerDelegate?
    var profile: ProfileService.Containers.Profile?

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureNavigationBar()
        configureNavigationItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let profile = profile {
            profileImageView.setImageWithProfile(profile)
            profileNameLabel.text = profile.full_name
            profileTitleLabel.text = profile.title
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        noteTextView.becomeFirstResponder()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        profileImageView.makeItCircular(false)
        noteTextView.addTopBorder(offset: nil)
        noteTextView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "NEW NOTE"
    }
    
    private func configureNavigationItems() {
        let closeButton = UIBarButtonItem(
            image: UIImage(named: "Down"),
            style: .Plain,
            target: self,
            action: "closeButtonTapped:"
        )
        navigationItem.leftBarButtonItem = closeButton
        let doneButton = UIBarButtonItem(
            image: UIImage(named: "CircleCheckFilled"),
            style: .Plain,
            target: self,
            action: "doneButtonTapped:"
        )
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButtonTapped(sender: AnyObject!) {
        self.dismiss()
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject!) {
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
    
    // MARK: - Helpers
    private func dismiss() {
        noteTextView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

}
