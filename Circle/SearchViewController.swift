//
//  SearchViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/23/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var searchHeaderContainerView: UIView!
    @IBOutlet weak private(set) var overlayButton: UIButton!
    
    private var data = [Card]()
    private var loggedInPerson: Person?
    private var searchHeaderView: SearchHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureSearchHeaderView()
        configureCollectionView()
        configureOverlayButton()
        (collectionView.dataSource as SearchLandingDataSource).loadData { (error) -> Void in
            if error == nil {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkUserAndPresentAuthViewController()
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
        (collectionView.dataSource as SearchLandingDataSource).registerDefaultCardHeader(collectionView)
        (collectionView.delegate as CardCollectionViewDelegate?)?.delegate = self
    }
    
    private func configureOverlayButton() {
        overlayButton.backgroundColor = UIColor.searchOverlayButtonBackgroundColor()
        overlayButton.opaque = true
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
            profileVC.showCloseOrBackButton = true
            profileVC.person = loggedInPerson
        }
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showListOfPeople", sender: collectionView)
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

    // MARK: - Orientation change

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
