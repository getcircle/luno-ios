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
    @IBOutlet weak private(set) var searchHeaderContainerView: UIView!
    @IBOutlet weak private(set) var overlayButton: UIButton!
    
    private var animatedRowIndexes = NSMutableIndexSet()
    private var loggedInPerson: Person?
    private var data = [Card]()
    private var searchHeaderView: SearchHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureSearchHeaderView()
        configureCollectionView()
        configureOverlayButton()
        loadData()
    }

    // MARK: - Configuration

    private func configureView() {
        view.backgroundColor = UIColor.viewBackgroundColor()
    }
    
    private func configureSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            searchHeaderView = nibViews.first as SearchHeaderView
            searchHeaderView.searchTextField.delegate = self
            searchHeaderContainerView.addSubview(searchHeaderView)
            searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
    }
    
    private func configureCollectionView() {
        collectionView!.backgroundColor = UIColor.viewBackgroundColor()
        collectionView!.registerNib(
            UINib(nibName: "ProfileImagesCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: ProfileImagesCollectionViewCell.classReuseIdentifier
        )
        
        collectionView!.registerNib(
            UINib(nibName: "CardHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: CardHeaderCollectionReusableView.classReuseIdentifier
        )
    }
    
    private func configureOverlayButton() {
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
        let people = objects as? [Person]
        let filteredList = people?.filter({ $0.email == PFUser.currentUser().email })
        if filteredList?.count == 1 {
            loggedInPerson = filteredList?[0]
        }
        
        let directReportsCard = Card(cardType: .People, title: "Direct Reports")
        if people?.count > 0 {
            directReportsCard.content.append(people!)
            directReportsCard.contentCount = people?.count ?? 0
        }
        data.append(directReportsCard)

        let peersCard = Card(cardType: .People, title: "Peers")
        if people?.count > 0 {
            peersCard.content.append(people!.reverse())
            peersCard.contentCount = people?.count ?? 0
        }
        data.append(peersCard)
        collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].content.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            ProfileImagesCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath) as ProfileImagesCollectionViewCell

        if let people = data[indexPath.section].content.first as? [Person] {
            cell.setPeople(people)
        }
        animate(cell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: CardHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
        ) as CardHeaderCollectionReusableView

        supplementaryView.cardTitleLabel.text = data[indexPath.section].title
        supplementaryView.cardImageView.image = UIImage(named: data[indexPath.section].imageSource)
        supplementaryView.cardContentCountLabel.text = "All " + String(data[indexPath.section].contentCount)
        return supplementaryView
    }

    // MARK: Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showListOfPeople", sender: collectionView.cellForItemAtIndexPath(indexPath))
    }
    
    // MARK: - Flow Layout Delegate

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 10.0, 20.0, 10.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var leftAndRightInsets = (collectionViewLayout as UICollectionViewFlowLayout).sectionInset.left
        leftAndRightInsets += (collectionViewLayout as UICollectionViewFlowLayout).sectionInset.right
        return CGSizeMake(collectionView.frameWidth - 20.0, ProfileImagesCollectionViewCell.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(view.frameWidth, CardHeaderCollectionReusableView.height)
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
//        else if segue.identifier == "showListOfPeople" {
//            let controller = segue.destinationViewController as PeopleViewController
//            if sender is ProfileImagesCollectionViewCell {
//                controller.navigationItem.title = (sender as ProfileImagesCollectionViewCell).cardTitleLabel.text?.capitalizedString
//            }
//        }
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
    
    // MARK: - Helpers

    private func animate(cell: UICollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if animatedRowIndexes.containsIndex(indexPath.row) == false {
            animatedRowIndexes.addIndex(indexPath.row)
            let finalFrame = cell.frame
            cell.frameY = finalFrame.origin.y + 40.0
            let delay = 0.2 * (Double(indexPath.row) + 1.0)
            cell.alpha = 0.0
            
            UIView.animateWithDuration(
                0.3,
                delay: delay,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.6,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    cell.frame = finalFrame
                    cell.alpha = 1.0
                },
                completion: nil
            )
        }

    }
}
