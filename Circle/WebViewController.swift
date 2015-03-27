//
//  WebViewController.swift
//  Circle
//
//  Created by Ravi Rani on 3/23/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var pageURLToLoad: String!
    
    private var webView: WKWebView!
    private var activityIndicatorView: CircleActivityIndicatorView!
    
    convenience init(pageURL: String) {
        self.init()
        pageURLToLoad = pageURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureWebView()
        assert(pageURLToLoad != nil, "URL of the page to be loaded should be set")
        loadPage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: "loading")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
        activityIndicatorView = view.addActivityIndicator()
    }
    
    private func configureWebView() {
        webView = WKWebView.newAutoLayoutView()
        webView.backgroundColor = UIColor.appViewBackgroundColor()
        webView.alpha = 0.0
        view.addSubview(webView)
        webView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }

    private func loadPage() {
        if let validURL = NSURL(string: pageURLToLoad) {
            let URLRequest = NSURLRequest(URL: validURL)
            webView.loadRequest(URLRequest)
        }
        else {
            println("Invalid URL provided")
        }
    }
    
    // MARK: - Observers
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "loading" {
            if let loading: Bool = change["new"] as? Bool {
                if !loading {
                    UIView.animateWithDuration(0.3) { () -> Void in
                        self.webView.alpha = 1.0
                        self.activityIndicatorView.stopAnimating()
                        self.title = self.webView.title
                    }
                }
            }
        }
    }
}
