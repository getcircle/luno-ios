//
//  SocialConnectViewController.swift
//  Circle
//
//  Created by Michael Hahn on 2/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import ProtobufRegistry
import UIKit
import WebKit

struct SocialConnectNotifications {
    
    static let onServiceConnectedNotification = "com.rhlabs.notification:onSocialServiceConnectedNotification"
    static let serviceProviderUserInfoKey = "provider"
    static let serviceUserUserInfoKey = "user"
    static let serviceIdentityUserInfoKey = "identity"
    static let serviceOAuthSDKDetailsUserInfoKey = "oauth_sdk_details"
}

class SocialConnectViewController: UIViewController, WKNavigationDelegate {

    var activityIndicator: CircleActivityIndicatorView!
    var webView: WKWebView!
    var provider: Services.User.Containers.IdentityV1.ProviderV1?
    var loginHint: String?
    var authorizationURL: String?
    
    convenience init(provider withProvider: Services.User.Containers.IdentityV1.ProviderV1, loginHint withLoginHint: String? = nil) {
        self.init()
        provider = withProvider
        loginHint = withLoginHint
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureWebView()
        loadWebView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeFromSuperview()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
        activityIndicator = view.addActivityIndicator(color: UIColor.appTintColor())
    }
    
    private func configureNavigationBar() {
        switch provider! {
        case .Linkedin:
            title = AppStrings.SocialConnectLinkedInCTA
        case .Google:
            title = AppStrings.SocialConnectGooglePlusCTA
        default:
            title = AppStrings.SocialConnectDefaultCTA
        }
        addCloseButtonWithAction("cancel:")
    }
    
    private func configureWebView() {
        webView = WKWebView.newAutoLayoutView()
        webView.navigationDelegate = self
        webView.alpha = 0.0
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        view.addSubview(webView)
        webView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
        webView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
    }
    
    private func loadWebView() {
        if let authorizationURL = authorizationURL {
            loadURL(authorizationURL)
        }
        else {
            Services.User.Actions.getAuthorizationInstructions(provider!, loginHint: loginHint) { (authorizationURL, error) -> Void in
                if let authorizationURL = authorizationURL {
                    self.loadURL(authorizationURL)
                }
            }
        }
    }

    private func loadURL(webURL: String) {
        let url = NSURL(string: webURL)
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.URL
        if url!.host == ServiceHttpRequest.environment.host && (url!.path!.hasSuffix("success") || url!.path!.hasSuffix("error")) {
            if url!.path!.hasSuffix("success") {
                var user: Services.User.Containers.UserV1?
                var identity: Services.User.Containers.IdentityV1?
                var authDetails: Services.User.Containers.OAuthSDKDetailsV1?
                if
                    let components = NSURLComponents(URL: url!, resolvingAgainstBaseURL: false),
                    items = components.queryItems as? [NSURLQueryItem] {
                    for item in items {
                        if let value = item.value, data = NSData(base64EncodedString: value, options: nil) {
                            switch item.name {
                            case "user": user = Services.User.Containers.UserV1.parseFromData(data)
                            case "identity": identity = Services.User.Containers.IdentityV1.parseFromData(data)
                            case "oauth_sdk_details": authDetails = Services.User.Containers.OAuthSDKDetailsV1.parseFromData(data)
                            default: break
                            }
                        }
                    }
                }
                if let user = user, identity = identity, authDetails = authDetails {
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        SocialConnectNotifications.onServiceConnectedNotification, 
                        object: self,
                        userInfo: [
                            SocialConnectNotifications.serviceProviderUserInfoKey: NSNumber(int: provider?.rawValue ?? 0),
                            SocialConnectNotifications.serviceUserUserInfoKey: user,
                            SocialConnectNotifications.serviceIdentityUserInfoKey: identity,
                            SocialConnectNotifications.serviceOAuthSDKDetailsUserInfoKey: authDetails
                        ]
                    )
                }
            } else {
                println("error connecting to provider")
            }
            decisionHandler(.Cancel)
            self.dismiss()
        } else {
            decisionHandler(.Allow)
        }
    }
    
    // MARK: - Observers
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "loading" {
            if let loading: Bool = change["new"] as? Bool {
                if !loading {
                    UIView.animateWithDuration(0.3) { () -> Void in
                        self.webView.alpha = 1.0
                    }
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func cancel(sender: AnyObject!) {
        dismiss()
    }
    
    // MARK: - Helpers
    
    private func dismiss() {
        webView.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }

}
