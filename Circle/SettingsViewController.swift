//
//  SettingsViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SettingsViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    private var dataSource = SettingsDataSource()
    private var collectionViewDelegate = CardCollectionViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureCollectionView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        dataSource.loadData { (error) -> Void in
            if error == nil {
                self.collectionView.reloadData()
            }
        }

        dataSource.registerCardHeader(collectionView)
        collectionView.dataSource = dataSource
        collectionViewDelegate.delegate = self
        collectionView.delegate = collectionViewDelegate
    }
    
    private func configureNavigationBar() {
        title = NSLocalizedString("Settings", comment: "Title of the settings view")
        let closeButtonItem = UIBarButtonItem(
            image: UIImage(named: "Down"), 
            style: .Plain, 
            target: self, 
            action: "closeButtonTapped:"
        )
        
        navigationItem.leftBarButtonItem = closeButtonItem
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButtonTapped(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject!) {
        dismissViewControllerAnimated(false, completion: { () -> Void in
            AuthViewController.logOut()
        })
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        switch dataSource.typeOfCell(indexPath) {
        case .LogOut:
            logoutButtonTapped(collectionView)

        case .SecurityPasscodeAndTouchID:
            let passcodeTouchIDViewController = PasscodeTouchIDViewController(
                nibName: "PasscodeTouchIDViewController", 
                bundle: nil
            )
            navigationController?.pushViewController(passcodeTouchIDViewController, animated: true)
            
        default:
            break
        }
    }
    
    // MARK: - Notifications
    
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didToggleProvider:",
            name: ToggleSocialConnectionCollectionViewCellNotifications.onProviderToggled,
            object: nil
        )
    }
    
    private func unregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didToggleProvider(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let enable = userInfo["enable"] as? Bool {
                if let identity = userInfo["identity"] as? UserService.Containers.Identity {
                    switch identity.provider {
                    case .Google:
                        if !enable {
                            GPPSignIn.sharedInstance().disconnect()
                            dismissViewControllerAnimated(true) { () -> Void in
                                AuthViewController.logOut()
                            }
                        }
                    case .Linkedin:
                        if enable {
                            let socialConnectVC = SocialConnectViewController(provider: .Linkedin)
                            presentViewController(socialConnectVC, animated: true, completion: nil)
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
}
