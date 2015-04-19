//
//  CircleErrorMessageView.swift
//  Circle
//
//  Created by Ravi Rani on 3/31/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import PureLayout

class CircleErrorMessageView: UIView {

    class var height: CGFloat {
        return 100.0
    }

    var error: NSError? {
        didSet {
            if messageLabel != nil {
                messageLabel.text = getMessage(error)
            }
        }
    }
    var errorHandler: (() -> Void)?
    
    private var messageLabel: UILabel!
    private var tryAgainButton: UIButton!
    
    init() {
        super.init(frame: CGRectZero)
        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    convenience init(error withError: NSError?, errorHandler withErrorHandler: (() -> Void)?) {
        self.init()
        error = withError
        errorHandler = withErrorHandler
        customInit()
    }
    
    private func customInit() {
        messageLabel = UILabel(forAutoLayout: ())
        messageLabel.backgroundColor = UIColor.appViewBackgroundColor()
        messageLabel.textColor = UIColor.blackColor()
        messageLabel.textAlignment = .Center
        messageLabel.font = UIFont.appMessageFont()
        messageLabel.text = getMessage(nil)
        messageLabel.numberOfLines = 0

        addSubview(messageLabel)
        messageLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        messageLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(10.0, 15.0, 0.0, 15.0), excludingEdge: .Bottom)
        
        tryAgainButton = UIButton(forAutoLayout: ())
        tryAgainButton.setTitle(AppStrings.GenericTryAgainButtonTitle, forState: .Normal)
        tryAgainButton.setTitleColor(UIColor.appTintColor(), forState: .Normal)
        tryAgainButton.tintColor = UIColor.appTintColor()
        tryAgainButton.backgroundColor = UIColor.whiteColor()
        tryAgainButton.titleLabel?.font = UIFont.appSecondaryActionCTAFont()
        tryAgainButton.addRoundCorners(radius: 2.0)
        addSubview(tryAgainButton)
        tryAgainButton.autoSetDimension(.Width, toSize: 140.0)
        tryAgainButton.autoSetDimension(.Height, toSize: 44.0)
        tryAgainButton.autoAlignAxisToSuperviewAxis(.Vertical)
        tryAgainButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: messageLabel, withOffset: 20.0)
        tryAgainButton.addTarget(self, action: "tryAgainButtonTapped:", forControlEvents: .TouchUpInside)
    }
    
    func tryAgainButtonTapped(sender: AnyObject!) {
        if let errorHandler = errorHandler {
            errorHandler()
        }
    }
    
    func isVisible() -> Bool {
        return alpha == 1.0
    }
    
    func show() {
        alpha = 1.0
    }

    func hide() {
        alpha = 0.0
    }
    
    private func getMessage(error: NSError?) -> String {
        // TODO: Return different messages based on error code
        return AppStrings.GenericErrorMessage
    }
}
