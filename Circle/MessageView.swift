//
//  MessageView.swift
//  Luno
//
//  Created by Ravi Rani on 10/19/15.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit

class MessageView: UIView {

    static let InfoMessageColor = UIColor(red: 88, green: 196, blue: 238)
    static let WarningMessageColor = UIColor(red: 253, green: 175, blue: 77)
    static let ErrorMessageColor = UIColor(red: 195, green: 54, blue: 4)
    
    enum MessageType {
        case Info
        case Error
        case Warning
        
        static func colorsByType(messageType: MessageType) -> UIColor {
            switch messageType {
            case .Info:
                return MessageView.InfoMessageColor
                
            case .Warning:
                return MessageView.WarningMessageColor
                
            case .Error:
                return MessageView.ErrorMessageColor
            }
        }
    }
    
    
    
    private(set) var message: String = ""
    private(set) var messageType: MessageType = .Info
    private var messageLabel: UILabel!
    
    init(message withMessage: String, messageType andType: MessageType) {
        super.init(frame: CGRectZero)
        customInit()
        setMessage(message: withMessage, messageType: andType)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        messageLabel = UILabel(forAutoLayout: ())
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.font = UIFont.regularFont(12.0)
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0
        addSubview(messageLabel)
        messageLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0))
    }
    
    func show(animated animated: Bool) {
        UIView.animateWithDuration(animated ? 0.3 : 0.0) { () -> Void in
            self.alpha = 1.0
        }
    }

    func hide(animated animated: Bool) {
        UIView.animateWithDuration(animated ? 0.3 : 0.0) { () -> Void in
            self.alpha = 0.0
        }
    }
    
    func setMessage(message withMessage: String, messageType andMessageType: MessageType) {
        message = withMessage
        messageType = andMessageType
        let backgroundColorByType = MessageType.colorsByType(messageType)
        messageLabel.backgroundColor = backgroundColorByType
        messageLabel.text = message
        backgroundColor = backgroundColorByType
    }
}
