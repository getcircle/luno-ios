//
//  ContactInfoViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/25/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MessageUI
import ProtobufRegistry
import StoreKit

class ContactInfoViewController: CircleAlertViewController, 
UICollectionViewDelegate, 
MFMailComposeViewControllerDelegate,
SKStoreProductViewControllerDelegate {

    // This can come from the backend
    struct AppURLS {
        private var nativeAppURL: String?
        private var webAppURL: String?
        private var appStoreID: Int?
        private var appStoreURL: String?
    }
    
    static let appURLByContactMethodType: [Services.Profile.Containers.ContactMethodV1.ContactMethodTypeV1: AppURLS] = [
        .Hipchat: AppURLS(
            nativeAppURL: "hipchat://www.hipchat.com/user/%@", 
            webAppURL: nil, 
            appStoreID: 418168984,
            appStoreURL: "https://itunes.apple.com/us/app/hipchat-group-chat-video-file/id418168984?mt=8"
        ),
        .Twitter: AppURLS(
            nativeAppURL: "twitter://user?screen_name=%@", 
            webAppURL: "http://www.twitter.com/%@", 
            appStoreID: 333903271,
            appStoreURL: "https://itunes.apple.com/us/app/twitter/id333903271?mt=8"
        ),
        .Facebook: AppURLS(
            nativeAppURL: "fb-messenger://profile",
            webAppURL: nil,
            appStoreID: 454638411,
            appStoreURL: "https://itunes.apple.com/us/app/facebook-messenger/id454638411?mt=8"
        ),
        .Skype: AppURLS(
            nativeAppURL: "skype:%@",
            webAppURL: nil,
            appStoreID: 304878510,
            appStoreURL: "https://itunes.apple.com/us/app/skype-for-iphone/id304878510?mt=8"
        ),
        .Slack: AppURLS(
            nativeAppURL: "slack://%@",
            webAppURL: nil,
            appStoreID: 618783545,
            appStoreURL: "https://itunes.apple.com/us/app/slack-team-communication/id618783545?mt=8"
        )
    ]
    
    var profile: Services.Profile.Containers.ProfileV1!

    private var collectionView: UICollectionView!
    private var collectionViewDelegate = CardCollectionViewDelegate()
    private var collectionViewDataSource: ContactInfoDataSource!
    private var collectionViewLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assert(profile != nil, "Profile should be set when presenting this view controller")
    }
    
    override func configureModalParentView() {
        parentContainerView.addRoundCorners(radius: 0.0)
        
        let titleLabel = UILabel(forAutoLayout: ())
        titleLabel.opaque = true
        titleLabel.backgroundColor = UIColor.appTintColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.appModalTitleLabelFont()
        titleLabel.textAlignment = .Center
        let titleText = AppStrings.TitleContactInfoView.localizedUppercaseString()
        titleLabel.attributedText = NSAttributedString(
            string: titleText,
            attributes: [
                NSKernAttributeName: NSNumber(double: 2.0),
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont.appModalTitleLabelFont()
            ]
        )
        parentContainerView.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        titleLabel.autoSetDimension(.Height, toSize: 60.0)
     
        collectionView = UICollectionView(
            frame: parentContainerView.bounds, 
            collectionViewLayout: collectionViewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.opaque = true
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        parentContainerView.addSubview(collectionView)
        collectionViewDataSource = ContactInfoDataSource(profile: profile)
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = collectionViewDelegate
        collectionViewDataSource.loadData { (error) -> Void in
            self.collectionView.reloadData()
        }
        collectionViewDelegate.delegate = self
        collectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        collectionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel)
        collectionView.autoSetDimension(.Height, toSize: collectionViewDataSource.heightOfContactInfoSection())
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let contactMethod = collectionViewDataSource.contactMethodAtIndexPath(indexPath) {
            switch contactMethod.contactMethodType {
            case .Email:
                presentMailViewController(
                    [contactMethod.value],
                    subject: "Hey",
                    messageBody: "",
                    completionHandler: nil
                )
            case .CellPhone, .Phone:
                if let phoneURL = NSURL(string: NSString(format: "tel://%@", contactMethod.value.removePhoneNumberFormatting()) as String) {
                    UIApplication.sharedApplication().openURL(phoneURL)
                }

            default:
                redirectUserToApplication(contactMethod)
                break
            }
        }
    }
    
    /*
        Redirects user to a specific service's app, website or app store page.
    
        The function checks through all the available options and redirects to the appropriate source.
        The logic here assumers any native app URLs and website URLs have a placeholder for the user identifier.
        These URLs are formatted using the NSString(format: "", args...) method.
    
        NOTE: This function should probably be part of some util file.

        :param: contactMethod Contact method for which the redirect is being requested
        :returns: Bool Boolean indicating whether a redirect did happen.
    */
    private func redirectUserToApplication(contactMethod: Services.Profile.Containers.ContactMethodV1) -> Bool {
        // TODO: Add Mixpanel tracking
        
        // Check there are some URLs defined for this contact method
        if let appURLForContactMethodType = self.dynamicType.appURLByContactMethodType[contactMethod.contactMethodType] {
            
            // NATIVE APP
            // Is there a native app URL and can it be opened
            if let appURL = appURLForContactMethodType.nativeAppURL where appURL.trimWhitespace() != "" {
                let appURLWithUserIdentifier = NSString(format: appURL, contactMethod.value)
                if let appNSURL = NSURL(string: appURLWithUserIdentifier as String) where UIApplication.sharedApplication().canOpenURL(appNSURL) {
                    UIApplication.sharedApplication().openURL(appNSURL)
                    return true
                }
            }
            
            // WEB APP
            // If we got here, we didn't have a valid native URL...now check for a web URL
            if let webURL = appURLForContactMethodType.webAppURL where webURL.trimWhitespace() != "" {
                let webURLWithUserIdentifier = NSString(format: webURL, contactMethod.value)
                if NSURL(string: webURLWithUserIdentifier as String) != nil {
                    // Redirect to generic webview controller
                    let webViewController = WebViewController(pageURL: webURLWithUserIdentifier as String)
                    let webViewNavigationController = UINavigationController(rootViewController: webViewController)
                    presentViewController(webViewNavigationController, animated: true, completion: nil)
                    return true
                }
            }
            
            // APP STORE
            // If we got here, we didn't have a valid native app or a web URL...now check for app store ID and URL
            // Check if we can open the app store view w/o leaving the app
            if let appStoreID = appURLForContactMethodType.appStoreID {
                weak var weakSelf = self
                presentOptionToDownloadAppFromStore(contactMethod, yesButtonHandler: { () -> Void in

                    let productViewController = SKStoreProductViewController()
                    productViewController.delegate = weakSelf
                    productViewController.loadProductWithParameters([
                        SKStoreProductParameterITunesItemIdentifier: NSNumber(integer: appStoreID)
                    ],
                    completionBlock: { (loaded, error) -> Void in
                        if loaded && error == nil {
                            weakSelf?.presentViewController(productViewController, animated: true, completion: {() -> Void in
                                UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
                            })
                        }
                    })
                })
                
                return true
            }

            if let appStoreURL = appURLForContactMethodType.appStoreURL where appStoreURL.trimWhitespace() != "" {
                if let appStoreNSURL = NSURL(string: appStoreURL) where UIApplication.sharedApplication().canOpenURL(appStoreNSURL) {
                    presentOptionToDownloadAppFromStore(contactMethod, yesButtonHandler: { () -> Void in
                        // Redirect to the app store
                        UIApplication.sharedApplication().openURL(appStoreNSURL)
                    })
                    return true
                }
            }
        }
        
        return false
    }
    
    private func presentOptionToDownloadAppFromStore(contactMethod: Services.Profile.Containers.ContactMethodV1, yesButtonHandler: () -> Void) {
        
        let alertController = UIAlertController(
            title: NSString(format: AppStrings.TitleDownloadAppAlert, contactMethod.label) as String,
            message: NSString(format: AppStrings.TextDownloadApp, contactMethod.label) as String,
            preferredStyle: .Alert
        )
        
        let yesAction = UIAlertAction(title: AppStrings.GenericYesButtonTitle, style: .Default, handler: { (action) -> Void in
            yesButtonHandler()
        })
        alertController.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: AppStrings.GenericNotNowButtonTitle, style: .Cancel, handler: { (action) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(
        controller: MFMailComposeViewController,
        didFinishWithResult result: MFMailComposeResult,
        error: NSError?
        ) {
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - SKStoreProductViewControllerDelegate
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
