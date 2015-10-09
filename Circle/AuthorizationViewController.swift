//
//  AuthorizationViewController.swift
//  Circle
//
//  Created by Michael Hahn on 2/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import ProtobufRegistry
import UIKit
import WebKit

struct AuthorizationNotifications {
    
    static let onServiceAuthorizedNotification = "com.rhlabs.notification:onServiceAuthorizedNotification"
    static let serviceProviderUserInfoKey = "provider"
    static let serviceUserUserInfoKey = "user"
    static let serviceIdentityUserInfoKey = "identity"
    static let serviceOAuthSDKDetailsUserInfoKey = "oauth_sdk_details"
    static let serviceSAMLDetailsUserInfoKey = "saml_details"
}

class AuthorizationViewController: UIViewController, WKNavigationDelegate {

    var activityIndicator: CircleActivityIndicatorView!
    var webView: WKWebView!
    var provider: Services.User.Containers.IdentityV1.ProviderV1?
    var providerName: String?
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
        activityIndicator = view.addActivityIndicator(UIColor.appTintColor())
    }
    
    private func configureNavigationBar() {
        switch provider! {
        case .Google, .Okta:
            if let providerName = providerName {
                title = NSString(format: AppStrings.SocialSignInCTA, providerName) as String
            } else {
                title = AppStrings.SocialConnectDefaultCTA
            }
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
        
        if let url = navigationAction.request.URL, host = url.host, path = url.path where (
            host.hasSuffix(ServiceHttpRequest.environment.redirectHostSuffix) &&
            (path.hasSuffix("success") || path.hasSuffix("error") || path.hasSuffix("auth"))
        ) {
            if path.hasSuffix("success") || path.hasSuffix("auth") {
                var user: Services.User.Containers.UserV1?
                var identity: Services.User.Containers.IdentityV1?
                var authDetails: Services.User.Containers.OAuthSDKDetailsV1?
                var samlDetails: Services.User.Containers.SAMLDetailsV1?
                if let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false) {
                    let items = components.queryItems!
                    for item in items {
                        if let value = item.value, data = NSData(base64EncodedString: value, options: []) {
                            do {
                                switch item.name {
                                case "user": user = try Services.User.Containers.UserV1.parseFromData(data)
                                case "identity": identity = try Services.User.Containers.IdentityV1.parseFromData(data)
                                case "oauth_sdk_details": authDetails = try Services.User.Containers.OAuthSDKDetailsV1.parseFromData(data)
                                case "saml_details": samlDetails = try Services.User.Containers.SAMLDetailsV1.parseFromData(data)
                                default: break
                                }
                            }
                            catch {
                                print("Error: \(error)")
                            }
                        }
                    }
                }
                if let user = user, identity = identity {
                    var userInfo: [String: AnyObject] = [
                        AuthorizationNotifications.serviceProviderUserInfoKey: NSNumber(int: provider?.rawValue ?? 0),
                        AuthorizationNotifications.serviceUserUserInfoKey: user,
                        AuthorizationNotifications.serviceIdentityUserInfoKey: identity,
                    ]
                    if let authDetails = authDetails {
                        userInfo[AuthorizationNotifications.serviceOAuthSDKDetailsUserInfoKey] = authDetails
                    } else if let samlDetails = samlDetails {
                        userInfo[AuthorizationNotifications.serviceSAMLDetailsUserInfoKey] = samlDetails
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        AuthorizationNotifications.onServiceAuthorizedNotification,
                        object: self,
                        userInfo: userInfo
                    )
                }
            } else {
                print("error connecting to provider")
            }
            decisionHandler(.Cancel)
            self.dismiss()
        } else {
            decisionHandler(.Allow)
        }
    }
    
    // MARK: - Observers
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "loading" {
            if let loading: Bool = change?["new"] as? Bool {
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
