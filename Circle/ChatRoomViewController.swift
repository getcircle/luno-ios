//
//  ChatRoomViewController.swift
//  Circle
//
//  Created by Michael Hahn on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ChatRoomViewController: SLKTextViewController {
    
    var chatRoom: ChatRoom?
    
    init(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
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

    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.whiteColor()
    }
    
    private func configureNavigation() {
        navigationItem.title = chatRoom?.description
    }
    
    // MARK: - SLKTextViewController Overrides
    
    override func didPressRightButton(sender: AnyObject!) {
        let message = MessageActions.sendMessage(chatRoom!, contents: textView.text)
        super.didPressRightButton(sender)
    }
}
