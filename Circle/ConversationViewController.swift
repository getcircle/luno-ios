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
}
