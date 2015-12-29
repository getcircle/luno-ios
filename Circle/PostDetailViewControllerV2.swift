//
//  PostDetailViewControllerV2.swift
//  Luno
//
//  Created by Ravi Rani on 12/27/15.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import MBProgressHUD
import ProtobufRegistry
import SafariServices

class PostDetailViewControllerV2: UIViewController,
UIScrollViewDelegate,
UIDocumentInteractionControllerDelegate,
WKNavigationDelegate {
    
    @IBOutlet weak private(set) var authorButton: UIButton!
    @IBOutlet weak private(set) var authorLabel: UILabel!
    @IBOutlet weak private(set) var authorImageView: CircleImageView!
    @IBOutlet weak private(set) var authorTitleLabel: UILabel!
    @IBOutlet weak private(set) var headerView: UIView!
    @IBOutlet weak private(set) var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var timestampLabel: UILabel!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var titleLabelTopConstraint: NSLayoutConstraint!

    var post: Services.Post.Containers.PostV1!
    
    static var templateString: String?

    private var activityIndicatorView: CircleActivityIndicatorView?
    private var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTitleAndTimestampViews()
        configureAuthorButton()
        configureAuthorViews()
        initAndConfigureWebView()
        Tracker.sharedInstance.trackPageView(
            pageType: .PostDetail,
            pageId: post.id
        )
        loadPost()
    }

    deinit {
        webView?.scrollView.delegate = nil
        webView?.navigationDelegate = nil
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.appViewBackgroundColor()
        navigationItem.title = AppStrings.KnowledgePostTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)        
        activityIndicatorView = view.addActivityIndicator()
        if let activityIndicatorView = activityIndicatorView {
            activityIndicatorView.startAnimating()
        }
    }
    
    private func configureTitleAndTimestampViews() {
        titleLabel.text = ""
        timestampLabel.text = ""
    }
    
    private func configureAuthorButton() {
        authorButton.setBackgroundImage(
            UIImage.imageFromColor(UIColor(red: 206, green: 206, blue: 206), withRect: authorButton.bounds),
            forState: .Highlighted
        )
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
            webView.scrollView.delegate = self
            webView.navigationDelegate = self
        }
    }
    
    // MARK: - Data Source
    
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
            let content = template
                .stringByReplacingOccurrencesOfString("{POST_TITLE}", withString: post.title)
                .stringByReplacingOccurrencesOfString("{POST_CONTENT}", withString: post.content)
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
        var contentInsets = webView.scrollView.contentInset
        contentInsets.top = headerViewHeight
        webView.scrollView.contentInset = contentInsets
    }

    // MARK: - IBActions
    
    @IBAction func authorTapped(sender: AnyObject) {
        showProfileDetail(post.byProfile)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {        
        headerViewTopConstraint.constant = -1 * (scrollView.contentInset.top + scrollView.contentOffset.y)
        headerView.setNeedsUpdateConstraints()
        headerView.layoutIfNeeded()
    }
    
    // MARK: - WKNavigationDelegate

    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        if let activityIndicatorView = activityIndicatorView {
            activityIndicatorView.stopAnimating()
        }
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.URL {
            
            if url.absoluteString == "about:blank" {
                // Allow initial load
                decisionHandler(.Allow)
                return
            }
            else if navigationAction.navigationType == .LinkActivated {
                // For link clicks
                // If supported file type, go preview it
                // If not supported file type, go to SafariVC on iOS 9 or actual browser on lower versions
                
                if canPreviewURL(url) {
                    // Download and Preview
                    downloadAndPreviewURL(url)
                }
                else {
                    // Go to the browser
                    openURLInBrowser(url)
                }
            }
        }

        decisionHandler(.Cancel)
    }
    
    // MARK: - UIDocumentInteractionControllerDelegate
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
        if let tempFileUrl = controller.URL {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(tempFileUrl)
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
    
    // MARK: - Helpers
    
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
    
    // For rich text posts, all attachments come as part of HTML
    // and there isn't a clean way (currently we can inject some javascript and read data-*
    // attributes to determine type and notify VC) to access them separately and check their types.
    // WKWebView also doesn't provide info on where a click happened.
    // It only gets a delegate callback with the actual URL.
    // The following code conservatively checks for popular file extensions
    // that we can preview. The full list is available here:
    // https://developer.apple.com/library/ios/documentation/NetworkingInternet/Reference/QLPreviewController_Class/index.html#//apple_ref/occ/cl/QLPreviewController
    private func canPreviewURL(url: NSURL) -> Bool {
        let supportedExtensions: Set<String> = [
            // Images
            "png", "jpeg", "jpg", "gif", "svg",

            // Text Documents
            "text", "txt", "rtf", "csv",
            
            // iWork
            "key", "pages", "numbers",
            
            // Office
            "docx", "doc", "xlsx", "xls", "ppt", "pptx",
            
            // PDF
            "pdf",
        ]
        
        if let fileExtension = url.pathExtension where supportedExtensions.contains(fileExtension)  {
            print(fileExtension)
            return true
        }
        
        return false
    }

    private func downloadAndPreviewURL(url: NSURL) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        Alamofire.request(.GET, url).response(completionHandler: { (request, response, data, error) -> Void in
            hud.hide(true)
            if let error = error {
                print("Error: \(error)")
            }
            else if let data = data {
                self.previewFileData(data, fileName: url.lastPathComponent)
            }
        })
    }
    
    private func previewFileData(data: NSData, fileName: String?) {
        if let fileName = fileName {
            // Write attachment data to a temp file so we can preview it
            let tempFileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .URLByAppendingPathComponent(fileName)
            do {
                try data.writeToURL(tempFileUrl, options: [])
                let documentInteractionController = UIDocumentInteractionController(URL: tempFileUrl)
                documentInteractionController.delegate = self
                documentInteractionController.presentPreviewAnimated(true)
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func openURLInBrowser(url: NSURL) {
        if #available(iOS 9, *) {
            let safariVC = SFSafariViewController(URL: url)
            presentViewController(safariVC, animated: true, completion: nil)
        }
        else {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
