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
}

class SocialConnectViewController: UIViewController, WKNavigationDelegate {
    
    var activityIndicator: CircleActivityIndicatorView!
    var webView: WKWebView!
    var provider: UserService.Provider?
    
    convenience init(provider withProvider: UserService.Provider) {
        self.init()
        provider = withProvider
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        configureWebView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadWebView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: "loading")
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
        activityIndicator = view.addActivityIndicator(color: UIColor.whiteColor())
    }
    
    private func configureNavigationBar() {
        title = AppStrings.SocialConnectLinkedInCTA
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
        UserService.Actions.getAuthorizationInstructions(provider!) { (authorizationURL, error) -> Void in
            if let authorizationURL = authorizationURL {
                let url = NSURL(string: authorizationURL)
                let request = NSURLRequest(URL: url!)
                self.webView.loadRequest(request)
            }
        }
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.URL
        if url.host == ServiceHttpRequest.environment.host && (url.path!.hasSuffix("success") || url.path!.hasSuffix("error")) {
            if url.path!.hasSuffix("success") {
                println("successfully connected to linkedin")
                
                NSNotificationCenter.defaultCenter().postNotificationName(
                    SocialConnectNotifications.onServiceConnectedNotification, 
                    object: nil, 
                    userInfo: [
                        SocialConnectNotifications.serviceProviderUserInfoKey: NSNumber(int: provider?.rawValue ?? 0)
                    ]
                )
            } else {
                println("error connecting to linkedin: \(url)")
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
