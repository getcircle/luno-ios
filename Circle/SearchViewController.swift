//
//  SearchViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/23/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SearchViewController: UIViewController,
UICollectionViewDelegate,
UITextFieldDelegate,
SearchHeaderViewDelegate,
CardHeaderViewDelegate {
    
    @IBOutlet weak private(set) var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var searchHeaderContainerView: UIView!
    
    private var data = [Card]()
    private var landingDataSource: SearchLandingDataSource!
    private var searchHeaderView: SearchHeaderView!
    private var queryDataSource: SearchQueryDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        configureSearchHeaderView()
        configureCollectionView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
        
        // Animate hiding for every time thereafter
        setStatusBarHidden(false)
        checkUserAndPresentAuthViewController()
        (collectionView.dataSource as? SearchLandingDataSource)?.loadData { (error) -> Void in
            if error == nil {
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }

    // MARK: - Configuration

    private func configureView() {
        view.backgroundColor = UIColor.viewBackgroundColor()
        // Hide without animation in viewDidLoad
        setStatusBarHidden(false, animated: false)
        // TODO add some check here for whether or not we're on production
        if let leftBarButton = navigationItem.leftBarButtonItem {
            if let leftBarView = leftBarButton.valueForKey("view") as? UIView {
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: "profileLongPressHandler:")
                leftBarView.addGestureRecognizer(longPressGesture)
            }
        }
    }
    
    private func configureSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            searchHeaderView = nibViews.first as SearchHeaderView
            searchHeaderView.delegate = self
            searchHeaderView.searchTextField.delegate = self
            searchHeaderView.searchTextField.addTarget(self, action: "search", forControlEvents: .EditingChanged)
            searchHeaderContainerView.addSubview(searchHeaderView)
            searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        (collectionView.delegate as CardCollectionViewDelegate?)?.delegate = self
        
        landingDataSource = SearchLandingDataSource()
        landingDataSource.registerDefaultCardHeader(collectionView)
        landingDataSource.cardHeaderDelegate = self
        collectionView.dataSource = landingDataSource
        
        queryDataSource = SearchQueryDataSource()
        queryDataSource.registerCardHeader(collectionView)
    }

    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        searchHeaderView.showCancelButton()
        collectionView.dataSource = queryDataSource
        collectionView.reloadData()
    }
    
    // MARK: - SearchHeaderViewDelegate
    
    func didCancel(sender: UIView) {
        collectionView.dataSource = landingDataSource
        queryDataSource.resetCards()
        collectionView.reloadData()
    }
    
    // MARK: Search Targets
    
    func search() {
        let query = searchHeaderView.searchTextField.text
        if query == "" {
            (collectionView.dataSource as SearchQueryDataSource).resetCards()
            collectionView.reloadData()
        } else {
            (collectionView.dataSource as SearchQueryDataSource).filter(searchHeaderView.searchTextField.text) { (error) -> Void in
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dataSource = (collectionView.dataSource as CardDataSource)
        let selectedCard = dataSource.cardAtSection(indexPath.section)!
        
        switch selectedCard.type {
        case .People, .Birthdays, .Anniversaries, .NewHires:
            if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
                let viewController = ProfileDetailViewController()
                viewController.profile = profile
                navigationController?.pushViewController(viewController, animated: true)
            }
        case .Group:
            let viewController = storyboard?.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
            viewController.dataSource.setInitialData(selectedCard.content[0] as [AnyObject])
            viewController.title = selectedCard.title
            navigationController?.pushViewController(viewController, animated: true)

        case .Locations:
            let viewController = LocationDetailViewController()
            navigationController?.pushViewController(viewController, animated: true)
            
        default:
            performSegueWithIdentifier("showListOfPeople", sender: collectionView)
        }
    }
    
    //MARK: - Tag Selected Notification
    
    func didSelectTag(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let selectedTag = userInfo["tag"] as? ProfileService.Containers.Tag {
                let viewController = TagDetailViewController()
                (viewController.dataSource as TagDetailDataSource).selectedTag = selectedTag
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // MARK: - Card Header View Delegate
    
    func cardHeaderTapped(card: Card!) {
        let dataSource = (collectionView.dataSource as CardDataSource)
        switch card.type {
        case .Group, .People, .Birthdays, .Anniversaries, .NewHires:
            let viewController = storyboard?.instantiateViewControllerWithIdentifier("ProfilesViewController") as ProfilesViewController
            if card.type == .Group {
                viewController.dataSource.setInitialData(card.content[0] as [AnyObject])
            }
            else {
                viewController.dataSource.setInitialData(card.allContent)
            }
            viewController.title = card.title
            navigationController?.pushViewController(viewController, animated: true)

        case .Locations:
            let viewController = LocationDetailViewController()
            navigationController?.pushViewController(viewController, animated: true)
            
        default:
            break
        }
    }

    // MARK: - Orientation change

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - IBActions
    
    @IBAction func showLoggedInUserProfile(sender: AnyObject!) {
        let profileVC = ProfileDetailViewController()
        profileVC.showCloseButton = true
        profileVC.profile = AuthViewController.getLoggedInUserProfile()
        let navController = UINavigationController(rootViewController: profileVC)
        navigationController?.presentViewController(navController, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject!) {
        (collectionView.dataSource as? CardDataSource)?.resetCards()
        collectionView.reloadData()
        AuthViewController.logOut()
    }
    
    @IBAction func profileLongPressHandler(sender: AnyObject!) {
        let verifyPhoneNumberVC = VerifyPhoneNumberViewController(nibName: "VerifyPhoneNumberViewController", bundle: nil)
        let onboardingNavigationController = UINavigationController(rootViewController: verifyPhoneNumberVC)
        presentViewController(onboardingNavigationController, animated: true, completion: nil)
    }
    
    // MARK: - Notifications
    
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didSelectTag:",
            name: TagsCollectionViewCellNotifications.onTagSelectedNotification,
            object: nil
        )
    }
    
    private func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
