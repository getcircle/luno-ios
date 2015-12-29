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
    
    @IBOutlet weak private(set) var authorLabel: UILabel!
    @IBOutlet weak private(set) var authorImageView: CircleImageView!
    @IBOutlet weak private(set) var authorTitleLabel: UILabel!
    @IBOutlet weak private(set) var headerView: UIView!
    @IBOutlet weak private(set) var timestampLabel: UILabel!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var titleLabelTopConstraint: NSLayoutConstraint!

    var post: Services.Post.Containers.PostV1!
    
    static var templateString: String?

    private var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTitleAndTimestampViews()
        configureAuthorViews()
        initAndConfigureWebView()
        loadPost()
    }

    // MARK: - Configuration
    
    private func configureView() {
        title = AppStrings.KnowledgePostTitle
    }
    
    private func configureTitleAndTimestampViews() {
        titleLabel.text = ""
        timestampLabel.text = ""
    }
    
    private func configureAuthorViews() {
        authorLabel.font = UIFont.mainTextFont()
        authorLabel.textColor = UIColor.appPrimaryTextColor()
        authorLabel.text = ""
        
        authorTitleLabel.font = UIFont.secondaryTextFont()
        authorTitleLabel.textColor = UIColor.appSecondaryTextColor()
        authorTitleLabel.text = ""
        
        authorImageView.makeItCircular()
        authorImageView.contentMode = .ScaleAspectFill
    }
    
    private func initAndConfigureWebView() {
        webView = WKWebView(forAutoLayout: ())
        if let webView = webView {
            view.insertSubview(webView, belowSubview: headerView)
            webView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    private func getTemplateString() -> String? {
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
        
        return self.dynamicType.templateString
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
        
        // Content
        if let template = self.getTemplateString() {
            let content = template.stringByReplacingOccurrencesOfString("{POST_CONTENT}", withString: post.content)
            webView.loadHTMLString(content, baseURL: nil)
        }
        
        // Title & Timestamp
        titleLabel.text = post.title
        if let timestamp = post.getFormattedChangedDate() {
            timestampLabel.text = " \u{2013} Last updated \(timestamp)"
        }
        
        // Author
        authorLabel.text = post.byProfile.fullName
        authorTitleLabel.text = post.byProfile.hasDisplayTitle ? post.byProfile.displayTitle : post.byProfile.title
        authorImageView.imageProfileIdentifier = post.byProfile.id
        authorImageView.setImageWithProfile(post.byProfile)
        
        // Size header and set content insets
        let titleSize = titleLabel.intrinsicContentSize()
        let headerViewHeight = titleLabelTopConstraint.constant + titleSize.height + titleLabelBottomConstraint.constant
        webView.scrollView.contentInset = UIEdgeInsetsMake(headerViewHeight, 0.0, 0.0, 0.0)
    }
}
