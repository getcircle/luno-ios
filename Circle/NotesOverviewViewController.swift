//
//  NotesOverviewViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class NotesOverviewViewController: UIViewController, UICollectionViewDelegate, NewNoteViewControllerDelegate {

    @IBOutlet weak private(set) var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    private(set) var dataSource = NotesOverviewDataSource()
    private(set) var delegate = CardCollectionViewDelegate()
    
    private var profileForSelectedNote: ProfileService.Containers.Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        configureCollectionView()
        configureNavigationButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        (collectionView.delegate as CardCollectionViewDelegate).delegate = self
        collectionView.bounces = true
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
        if let selectedNote = dataSource.contentAtIndexPath(indexPath)? as? NoteService.Containers.Note {
            if let profiles = selectedCard.metaData as? [ProfileService.Containers.Profile] {
                if let selectedProfile = profiles[indexPath.row] as ProfileService.Containers.Profile? {
                    let viewController = NewNoteViewController(nibName: "NewNoteViewController", bundle: nil)
                    profileForSelectedNote = selectedProfile
                    viewController.profile = selectedProfile
                    viewController.delegate = self
                    viewController.note = selectedNote
                    navigationController?.pushViewController(viewController, animated: true)
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
    
    func didAddNote(note: NoteService.Containers.Note) {
        if let profile = profileForSelectedNote {
            dataSource.addNote(note, forProfile: profile)
            loadData()
        }
    }
    
    func didDeleteNote(note: NoteService.Containers.Note) {
        if let profile = profileForSelectedNote {
            dataSource.removeNote(note, forProfile: profile)
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
        navigationController?.pushViewController(viewController, animated: true)
    }
}
