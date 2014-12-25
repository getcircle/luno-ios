//
//  SearchViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/23/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var overlayButton: UIButton!
    
    private var loggedInPerson: Person?
    private var people: [Person]?
    private var searchHeaderView: SearchHeaderCollectionReusableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeCollectionView()
        customizeOverlayButton()
        loadData()
    }

    // MARK: - Configuration

    private func customizeCollectionView() {
        collectionView!.backgroundColor = UIColor.viewBackgroundColor()
        collectionView!.registerNib(
            UINib(nibName: "SearchViewCardCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: SearchViewCardCollectionViewCell.classReuseIdentifier
        )
        
        collectionView!.registerNib(
            UINib(nibName: "SearchHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: SearchHeaderCollectionReusableView.classReuseIdentifier
        )
    }
    
    private func customizeOverlayButton() {
        overlayButton.backgroundColor = UIColor.searchOverlayButtonBackgroundColor()
        overlayButton.opaque = true
    }
    
    // MARK: - Load Data
    
    private func loadData() {
        if let pfUser = PFUser.currentUser() {
            
            let parseQuery = Person.query() as PFQuery
            parseQuery.cachePolicy = kPFCachePolicyCacheElseNetwork
            parseQuery.includeKey("manager")
            parseQuery.orderByAscending("firstName")
            parseQuery.findObjectsInBackgroundWithBlock({ (objects, error: NSError!) -> Void in
                if error == nil {
                    self.setPeople(objects)
                }
            })
        }
    }
    
    private func setPeople(objects: [AnyObject]!) {
        people = objects as? [Person]
        let filteredList = people?.filter({ $0.email == PFUser.currentUser().email })
        if filteredList?.count == 1 {
            loggedInPerson = filteredList?[0]
        }
        collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people?.count > 0 ? 2 : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            SearchViewCardCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath) as SearchViewCardCollectionViewCell

        if let peopleGroup = people as [Person]? {
            // TODO: - Remove hardcoded logic
            cell.cardTitleLabel.text = indexPath.row == 0 ? "Direct Reports" : "Peers"
            cell.cardTitleLabel.text = cell.cardTitleLabel.text?.uppercaseString
            cell.setPeople(indexPath.row == 0 ? peopleGroup : peopleGroup.reverse())
        }

        let finalFrame = cell.frame
        cell.frameY = finalFrame.origin.y + (view.frameHeight - finalFrame.origin.y)
        let delay = 0.2 * (Double(indexPath.row) + 1.0)

        UIView.animateWithDuration(
            0.9,
            delay: delay,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.6,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                cell.frame = finalFrame
            },
            completion: nil
        )

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: SearchHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
        ) as SearchHeaderCollectionReusableView
        
        searchHeaderView = supplementaryView
        searchHeaderView.searchTextField.delegate = self
        return supplementaryView
    }

    // MARK: Collection View Delegate
    
    
    // MARK: - Flow Layout Delegate

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake((section == 0 ? 5.0 : 15.0), 0.0, 0.0, 0.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frameWidth, 90.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(view.frameWidth, SearchHeaderCollectionReusableView.height)
        }

        return CGSizeZero
    }
    
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        searchHeaderView.showCancelButton()
        onSearchTextFieldBeginFocus()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        overlayButtonTapped(textField)
        onSearchTextFieldRemoveFocus()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        overlayButtonTapped(textField)
        onSearchTextFieldRemoveFocus()
        return true
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUserProfile" {
            let controller = segue.destinationViewController as UINavigationController
            let profileVC = controller.topViewController as ProfileViewController
            profileVC.showCloseButton = true
            profileVC.person = loggedInPerson
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func overlayButtonTapped(sender: AnyObject!) {
        searchHeaderView.searchTextField.resignFirstResponder()
        searchHeaderView.hideCancelButton()
    }

    // MARK: - Helpers
    
    private func onSearchTextFieldBeginFocus() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.overlayButton.alpha = 1.0
        })
    }
    
    private func onSearchTextFieldRemoveFocus() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.overlayButton.alpha = 0.0
        })
    }
}
