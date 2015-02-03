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

class SocialConnectViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var socialIconImageView: UIImageView!
    
    var webView: WKWebView!
    var provider: UserService.Provider?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureWebView()
        configureProvider()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appTintColor()
        infoLabel.textColor = UIColor.whiteColor()
    }
    
    private func configureWebView() {
        webView = WKWebView.newAutoLayoutView()
        webView.navigationDelegate = self
        webView.alpha = 0.0
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        view.addSubview(webView)
        webView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    private func configureProvider() {
        UserService.Actions.getAuthorizationInstructions(provider!) { (authorizationURL, error) -> Void in
            if let authorizationURL = authorizationURL {
                let url = NSURL(string: authorizationURL)
                let request = NSURLRequest(URL: url!)
                self.webView.loadRequest(request)
            }
        }
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let redirectURL = webView.URL {
            if redirectURL.host == ServiceHttpRequest.environment.host && (redirectURL.path!.hasSuffix("success") || redirectURL.path!.hasSuffix("error")) {
                if redirectURL.path!.hasSuffix("success") {
                    println("successfully connected to linkedin")
                } else {
                    println("error connecting to linkedin: \(redirectURL.path!)")
                }
                webView.removeObserver(self, forKeyPath: "loading")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
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

}
