//
//  NotesOverviewViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class NotesOverviewViewController: UIViewController,
    UICollectionViewDelegate,
    NewNoteViewControllerDelegate,
    SearchHeaderViewDelegate
{

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var searchContainerView: UIView!
    
    private(set) var dataSource = NotesOverviewDataSource()
    private(set) var delegate = CardCollectionViewDelegate()
    
    private var activityIndicatorView: CircleActivityIndicatorView!
    private var profileForSelectedNote: Services.Profile.Containers.ProfileV1?
    private var searchHeaderView: SearchHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        configureCollectionView()
        configureNavigationButtons()
        configureSearchHeaderView()
        configureActivityIndicatorView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
    }
    
    private func configureActivityIndicatorView() {
        activityIndicatorView = view.addActivityIndicator()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        (collectionView.delegate as! CardCollectionViewDelegate).delegate = self
        collectionView.bounces = true
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.alwaysBounceVertical = true
    }
    
    private func configureNavigationButtons() {
        let addBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Add"),
            style: .Plain, 
            target: self, 
            action: "addNewNoteButtonTapped:"
        )
        navigationItem.rightBarButtonItem = addBarButtonItem
    }

    private func configureSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            searchHeaderView = nibViews.first as! SearchHeaderView
            searchHeaderView.delegate = self
            searchHeaderView.searchTextField.placeholder = NSLocalizedString("Filter notes",
                comment: "Placeholder for text field used for filtering notes")
            searchHeaderView.searchTextField.addTarget(self, action: "filterNotes:", forControlEvents: .EditingChanged)
            searchContainerView.addSubview(searchHeaderView)
            searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            searchHeaderView.layer.cornerRadius = 10.0
        }
    }
    
    // MARK: - Load Data
    
    private func loadData() {
        dataSource.loadData { (error) -> Void in
            if error == nil {
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCard = dataSource.cardAtSection(indexPath.section)!        
        if let selectedNote = dataSource.contentAtIndexPath(indexPath) as? Services.Note.Containers.NoteV1 {
            if let profiles = selectedCard.metaData as? [String: Services.Profile.Containers.ProfileV1] {
                if let selectedProfile = profiles[selectedNote.forProfileId] as Services.Profile.Containers.ProfileV1? {
                    let viewController = NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
                    profileForSelectedNote = selectedProfile
                    viewController.profile = selectedProfile
                    viewController.delegate = self
                    viewController.note = selectedNote
                    trackViewNoteAction(selectedNote)
                    navigationController?.pushViewController(viewController, animated: true)
                    if searchHeaderView.searchTextField.text.trimWhitespace() == "" {
                        searchHeaderView.searchTextField.resignFirstResponder()
                    }
                }
            }
        }
    }
    
    // MARK: - Orientation change
    
    //    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    //        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    //        (collectionView.collectionViewLayout as UICollectionViewFlowLayout).itemSize = CGSizeMake(size.width, rowHeight)
    //        collectionView.collectionViewLayout.invalidateLayout()
    //    }
    
    // MARK: - NewNoteViewControllerDelegate
    
    func didAddNote(note: Services.Note.Containers.NoteV1) {
        if let profile = profileForSelectedNote {
            dataSource.addNote(note, forProfile: profile)
            filterNotes(nil)
            loadData()
        }
    }
    
    func didDeleteNote(note: Services.Note.Containers.NoteV1) {
        if let profile = profileForSelectedNote {
            dataSource.removeNote(note, forProfile: profile)
            filterNotes(nil)
            loadData()
        }
    }
    
    // MARK: IBActions
    
    @IBAction func addNewNoteButtonTapped(sender: AnyObject!) {

        // By default allow users to add notes for their own profile
        let loggedInUserProfile = AuthViewController.getLoggedInUserProfile()
        let viewController = NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
        viewController.profile = loggedInUserProfile
        viewController.delegate = self
        profileForSelectedNote = loggedInUserProfile
        trackNewNoteAction()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        dataSource.filterNotes("")
        loadData()
    }
    
    func filterNotes(sender: AnyObject?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            self.dataSource.filterNotes(self.searchHeaderView.searchTextField.text)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.loadData()
            })
        })
    }
    
    // MARK: - Tracking
    
    private func trackNewNoteAction() {
        let properties = getTrackingProperties(nil)
        Tracker.sharedInstance.track(.NewNote, properties: properties)
    }
    
    private func trackViewNoteAction(note: Services.Note.Containers.NoteV1) {
        let properties = getTrackingProperties(note)
        Tracker.sharedInstance.track(.ViewNote, properties: properties)
    }
    
    private func getTrackingProperties(note: Services.Note.Containers.NoteV1?) -> [TrackerProperty] {
        var properties = [
            TrackerProperty.withKey(.Source).withSource(.Overview),
            TrackerProperty.withKey(.SourceOverviewType).withOverviewType(.Notes),
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Note)
        ]
        if let note = note {
            properties.append(TrackerProperty.withDestinationId("note_id").withString(note.id))
            properties.append(TrackerProperty.withKeyString("personal_note").withValue(isPersonalNote(note.forProfileId)))
        } else {
            properties.append(TrackerProperty.withKeyString("personal_note").withValue(true))
        }
        return properties
    }
    
    private func isPersonalNote(forProfileId: String) -> Bool {
        if forProfileId == AuthViewController.getLoggedInUserProfile()!.id {
            return true
        }
        return false
    }
}
