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
    private var data = [Card]()
    private var loggedInPerson: Person?
    private var prototypeCellsHolder = [String: CircleCollectionViewCell]()
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
            UINib(nibName: "LocationsCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: LocationsCollectionViewCell.classReuseIdentifier
        )
        collectionView!.registerNib(
            UINib(nibName: "TagsCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: TagsCollectionViewCell.classReuseIdentifier
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
    
    private func addAdditionalData() {
        var tagsCard = Card(cardType: .Tags, title: "Tags")
        tagsCard.contentCount = 30
        var tags = [[String: String]]()
        tags.append(["name": "Python"])
        tags.append(["name": "Startups"])
        tags.append(["name": "Investing"])
        tags.append(["name": "iOS"])
        tags.append(["name": "Software Development"])
        tags.append(["name": "Marketing"])
        tagsCard.content.append(tags)
        data.append(tagsCard)

        var locationsCard = Card(cardType: .Locations, title: "Locations")
        locationsCard.contentCount = 6
        // Once we have the backend in place, these would be Location model objects
        locationsCard.content.append(["name": "San Francisco, CA", "address": "155 5th Street, 7th Floor", "count": "375"])
        locationsCard.content.append(["name": "Nashville, TN", "address": "Cummins Station", "count": "48"])
        locationsCard.content.append(["name": "London, UK", "address": "344-354 Gray's Inn Road", "count": "18"])
        data.append(locationsCard)
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
        
        // Calling it here because all this is fake and ideally this will all come from the server
        addAdditionalData()
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
        let card = data[indexPath.section]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            card.contentClass.classReuseIdentifier,
            forIndexPath: indexPath
        ) as CircleCollectionViewCell
        
        cell.setData(card.content[indexPath.row])
        animate(cell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: CardHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
        ) as CardHeaderCollectionReusableView

        animate(headerView, atIndexPath: indexPath)
        headerView.cardTitleLabel.text = data[indexPath.section].title
        headerView.cardImageView.image = UIImage(named: data[indexPath.section].imageSource)
        headerView.cardContentCountLabel.text = "All " + String(data[indexPath.section].contentCount)
        return headerView
    }

    // MARK: Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showListOfPeople", sender: collectionView.cellForItemAtIndexPath(indexPath))
    }
    
    // MARK: - Flow Layout Delegate

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        let card = data[section]
        return card.contentClass.interItemSpacing
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        let card = data[section]
        return card.contentClass.lineSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let card = data[section]
        return card.contentClass.sectionInset
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // Use default width and height methods if size calculation method of choice is Fixed
        let card = data[indexPath.section]
        if card.contentClass.sizeCalculationMethod == SizeCalculation.Fixed {
            var leftAndRightInsets = (collectionViewLayout as UICollectionViewFlowLayout).sectionInset.left
            leftAndRightInsets += (collectionViewLayout as UICollectionViewFlowLayout).sectionInset.right
            return CGSizeMake(card.contentClass.width - 20.0, card.contentClass.height)
        }
        else {

            // Use a prototype cell if size calculation method of choice is Dynamic
            // Instantiate a prototype cell and cache it for later use
            if prototypeCellsHolder[card.title] == nil {
                let cellNibViews = NSBundle.mainBundle().loadNibNamed(card.contentClassName, owner: self, options: nil)
                prototypeCellsHolder[card.title] = cellNibViews.first as? CircleCollectionViewCell
            }
            
            if let prototypeCell = prototypeCellsHolder[card.title] {
                prototypeCell.setData(card.content[indexPath.row])
                prototypeCell.setNeedsLayout()
                prototypeCell.layoutIfNeeded()
                return prototypeCell.intrinsicContentSize()
            }
        }
        
        return CGSizeZero
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
    
    private func animate(view: UICollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        var uniqueIndex: String
        
        // Unique indexes make sure each item or supplementary view animates only once
        if view is UICollectionViewCell {
            uniqueIndex = String(indexPath.section) + String(indexPath.row)
        }
        else {
            uniqueIndex = String((indexPath.section + 1) * 1000)
        }
        
        let intIndex = uniqueIndex.toInt() ?? 0
        if animatedRowIndexes.containsIndex(intIndex) == false {
            animatedRowIndexes.addIndex(intIndex)
            let finalFrame = view.frame
            view.frameY = finalFrame.origin.y + 40.0
            
            // Delay is based on section index to ensure all components of one section
            // animate in at the same time
            let delay = 0.2 * (Double(indexPath.section) + 1.0)
            view.alpha = 0.0
            
            UIView.animateWithDuration(
                0.5,
                delay: delay,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.6,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    view.frame = finalFrame
                    view.alpha = 1.0
                },
                completion: nil
            )
        }

    }
}
