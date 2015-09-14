//
//  SettingsViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MessageUI
import ProtobufRegistry

class SettingsViewController: UIViewController, UICollectionViewDelegate, MFMailComposeViewControllerDelegate {

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

    @IBAction func logoutDisconnectButtonTapped(sender: AnyObject!) {
        if let identities = AuthViewController.getLoggedInUserIdentities() {
            for identity in identities {
                if identity.provider == .Google {
                    Services.User.Actions.deleteIdentity(identity) { (error) -> Void in
                        if error != nil {
                            println("error deleting user identity: \(error)")
                        } else {
                            self.dismissViewControllerAnimated(true) { () -> Void in
                                AuthViewController.logOut()
                            }
                        }
                    }
                    
                    break
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        switch dataSource.typeOfCell(indexPath) {
        case .ContactEmail:
            var message = "\n\n\n\n\n"
            message += "------------------"
            message += "\n"
            message += NSString(format:"Version: %@ (%@)", NSBundle.appVersion(), NSBundle.appBuild()) as String
            message += "\n"
            message += NSString(format:"OS Version: %@ (%@)", UIDevice.currentDevice().systemName, UIDevice.currentDevice().systemVersion) as String
            message += "\n"
            message += NSString(format:"Device: %@", UIDevice.currentDevice().modelName) as String
            
            presentMailViewController(
                ["Luno Feedback<feedback@lunohq.com>"],
                subject: AppStrings.EmailFeedbackSubject + " - v" + NSBundle.appVersion(),
                messageBody: message,
                completionHandler: nil
            )
            
        case .Disconnect:
            logoutDisconnectButtonTapped(collectionView)
            
        case .LogOut:
            logoutButtonTapped(collectionView)

        case .SecurityPasscodeAndTouchID:
            let passcodeTouchIDViewController = PasscodeTouchIDViewController(
                nibName: "PasscodeTouchIDViewController",
                bundle: nil
            )
            navigationController?.pushViewController(passcodeTouchIDViewController, animated: true)

        case .LegalAttributions:
            let webViewController = WebViewController(pageURL: AttributionsURL)
            navigationController?.pushViewController(webViewController, animated: true)

        case .LegalPrivacy:
            let webViewController = WebViewController(pageURL: PrivacyPolicyURL)
            navigationController?.pushViewController(webViewController, animated: true)

        case .LegalTermsOfService:
            let webViewController = WebViewController(pageURL: TermsURL)
            navigationController?.pushViewController(webViewController, animated: true)

        default:
            break
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(
        controller: MFMailComposeViewController!,
        didFinishWithResult result: MFMailComposeResult,
        error: NSError!
        ) {
            dismissViewControllerAnimated(true, completion: nil)
    }
}
