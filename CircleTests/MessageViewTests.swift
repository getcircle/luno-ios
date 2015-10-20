//
//  MessageViewTests.swift
//  Luno
//
//  Created by Ravi Rani on 10/20/15.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import XCTest
@testable import luno

class MessageViewTests: XCTestCase {
    
    private let message = "Test Message"
    
    func testGetBackgroundColor() {
        let messageView = MessageView(message: message, messageType: .Info)
        XCTAssertEqual(messageView.backgroundColor, MessageView.InfoMessageColor)

        messageView.setMessage(message: message, messageType: .Warning)
        XCTAssertEqual(messageView.backgroundColor, MessageView.WarningMessageColor)
        
        messageView.setMessage(message: message, messageType: .Error)
        XCTAssertEqual(messageView.backgroundColor, MessageView.ErrorMessageColor)
    }
}
