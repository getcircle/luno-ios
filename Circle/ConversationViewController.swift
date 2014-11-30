//
//  ConversationViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ConversationViewController: SLKTextViewController {
    
    var recipient: Person?
    
    override init!(collectionViewLayout layout: UICollectionViewLayout!) {
        super.init(collectionViewLayout: layout)
        hidesBottomBarWhenPushed = true
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureView()
    }
    
    class func instance() -> ConversationViewController {
        return ConversationViewController(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.whiteColor()
    }
    
    private func configureNavigation() {
        navigationItem.title = recipient?.description
    }
    
    // MARK: - SLKTextViewController Overrides
    
    override func didPressRightButton(sender: AnyObject!) {
        let message = MessageActions.sendMessage(recipient!, contents: textView.text)
        super.didPressRightButton(sender)
    }
}
