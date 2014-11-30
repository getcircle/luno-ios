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
        self.hidesBottomBarWhenPushed = true
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigation()
        self.configureView()
    }
    
    class func instance() -> ConversationViewController {
        return ConversationViewController(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = self.recipient?.description
    }
    
    // MARK: - SLKTextViewController Overrides
    
    override func didPressRightButton(sender: AnyObject!) {
        let message = MessageActions.sendMessage(self.recipient!, recipient: self.recipient!, contents: self.textView.text)
        super.didPressRightButton(sender)
    }
}
