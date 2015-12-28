//
//  PostDetailViewControllerV2.swift
//  Luno
//
//  Created by Ravi Rani on 12/27/15.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import WebKit
import ProtobufRegistry

class PostDetailViewControllerV2: UIViewController {
    
    @IBOutlet weak private(set) var contentView: UIWebView!
    
    var post: Services.Post.Containers.PostV1!
    private var webView: WKWebView?
    static var templateString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAndConfigureWebView()
        loadPost()
    }

    private func initAndConfigureWebView() {
        webView = WKWebView(forAutoLayout: ())
        if let webView = webView {
            view.addSubview(webView)
            webView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    private func loadPost() {
        Services.Post.Actions.getPost(post.id) { (post, error) -> Void in
            if let post = post {
                self.post = post
                self.populateData()
            }
        }
    }
    
    private func populateData() {
        guard let webView = webView else {
            print("Web view not initialized correctly!")
            return
        }
        
        if self.dynamicType.templateString == nil {
            do {
                print("Fetching template")
                if let templateFile = NSBundle.mainBundle().pathForResource("PostTemplate", ofType: "html") {
                    let htmlTemplate = try NSString(contentsOfFile: templateFile, encoding: 4)
                    self.dynamicType.templateString = htmlTemplate as String
                }
            }
            catch {
                print("Error: \(error)")
            }
        }
        
        if let template = self.dynamicType.templateString {
            let content = template.stringByReplacingOccurrencesOfString("{POST_CONTENT}", withString: post.content)
            webView.loadHTMLString(content, baseURL: nil)
        }
    }
}
