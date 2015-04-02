//
//  TokenField.swift
//  Circle
//
//  Created by Michael Hahn on 3/30/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

private let InputTextFieldMinimumWidth: CGFloat = 100.0

@objc protocol TokenFieldDataSource {
    optional func tokenField(tokenField: TokenField, titleForTokenAtIndex index: UInt) -> String
    optional func numberOfTokensInTokenField(tokenField: TokenField) -> UInt
}

@objc protocol TokenFieldDelegate {
    optional func tokenField(tokenField: TokenField, didEnterText text: String)
    optional func tokenField(tokenField: TokenField, didDeleteTokenAtIndex index: UInt)
    optional func tokenField(tokenField: TokenField, didChangeText text: String)
    optional func tokenFieldDidBeginEditing(tokenField: TokenField)
}

class TokenField: UIView, UITextFieldDelegate {
    
    var tokenHeight: CGFloat = 35.0
    var dataSource: TokenFieldDataSource?
    var delegate: TokenFieldDelegate?
    var maxHeight: CGFloat?
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var contentViewHeightConstraint: NSLayoutConstraint?
    private var inputTextField: UITextField?
    
    private var tokenConstraints = [NSLayoutConstraint]()
    private var intrinsicHeight: CGFloat = 0.0
    private var updateConstraintsCalled = false
    
    override init() {
        super.init()
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        configureScrollView()
        configureContentView()
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView.newAutoLayoutView()
        addSubview(scrollView)
        UIView.autoSetIdentifier("ScrollView PinEdgesToSuperViewEdges", forConstraints: { () -> Void in
            self.scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            return
        })
    }
    
    private func configureContentView() {
        contentView = UIView.newAutoLayoutView()
        scrollView.addSubview(contentView)
        UIView.autoSetPriority(750, forConstraints: { () -> Void in
            self.contentView.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            self.contentView.autoSetContentCompressionResistancePriorityForAxis(.Horizontal)
        })
        contentView.autoMatchDimension(.Width, toDimension: .Width, ofView: self).autoIdentify("ContentView Width")
        UIView.autoSetIdentifier("ContentView PinEdgesToSuperViewEdges", forConstraints: { () -> Void in
            self.contentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            return
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        focusInputTextField()
    }
    
    override func updateConstraints() {
        if needsUpdateConstraints() {
            if !updateConstraintsCalled {
                updateConstraintsCalled = true
                updateTokenConstraints()
                updateConstraintsCalled = false
            }
            super.updateConstraints()
        }
    }
    
    func layoutTokens() {
        if tokenConstraints.count > 0 {
            (tokenConstraints as NSArray).autoRemoveConstraints()
            tokenConstraints.removeAll(keepCapacity: false)
        }
        
        for view in contentView.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        let leftPadding: CGFloat = 10.0
        for (var index: UInt = 0; index < numberOfTokens(); index++) {
            let title = titleForTokenAtIndex(index)
            let token = TagToken.newAutoLayoutView()
            token.setTitle(title)
            contentView.addSubview(token)
            token.autoSetDimension(.Width, toSize: UIScreen.mainScreen().bounds.width - leftPadding, relation: .LessThanOrEqual)
        }
        
        inputTextField = UITextField.newAutoLayoutView()
        inputTextField?.delegate = self
        inputTextField?.addTarget(self, action: "inputTextFieldDidChange:", forControlEvents: .EditingChanged)
        contentView.addSubview(inputTextField!)
        inputTextField?.autoSetDimension(.Width, toSize: UIScreen.mainScreen().bounds.width - leftPadding, relation: .LessThanOrEqual)
        inputTextField?.autoSetDimension(.Width, toSize: 80.0, relation: .GreaterThanOrEqual)
        inputTextField?.autoSetDimension(.Height, toSize: tokenHeight)
        UIView.autoSetPriority(1000, forConstraints: { () -> Void in
            self.inputTextField?.autoSetContentCompressionResistancePriorityForAxis(.Horizontal)
            return
        })
        inputTextField?.becomeFirstResponder()
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
    
    private func updateTokenConstraints() {
        var previousView: UIView?
        let leftOffset: CGFloat = 10.0
        let itemMargin: CGFloat = 10.0
        let topPadding: CGFloat = 10.0
        let bottomPadding: CGFloat = 10.0
        let itemVerticalMargin: CGFloat = 10.0
        var currentX = leftOffset
        intrinsicHeight = topPadding
        var lineIndex = 0
        // TODO figure out how to not need this
        let width = UIScreen.mainScreen().bounds.width
        for view in contentView.subviews as [UIView] {
            let size = view.intrinsicContentSize()
            if previousView != nil {
                tokenConstraints.append(view.autoPinEdgeToSuperviewEdge(.Top, withInset: topPadding, relation: .GreaterThanOrEqual))
                tokenConstraints.append(view.autoPinEdgeToSuperviewEdge(.Leading, withInset: leftOffset, relation: .GreaterThanOrEqual))
                currentX += itemMargin
                var viewWidth = size.width
                if view is UITextField {
                    viewWidth = width - currentX
                    if viewWidth < InputTextFieldMinimumWidth {
                        viewWidth = width - leftOffset
                        tokenConstraints.append(view.autoSetDimension(.Width, toSize: width - leftOffset))
                    } else {
                        tokenConstraints.append(view.autoSetDimension(.Width, toSize: viewWidth))
                    }
                }

                if currentX + viewWidth <= width {
                    tokenConstraints.append(view.autoConstrainAttribute(.Leading, toAttribute: .Trailing, ofView: previousView!, withOffset: itemMargin, relation: .Equal))
                    tokenConstraints.append(view.autoAlignAxis(.Horizontal, toSameAxisOfView: previousView!))
                    currentX += viewWidth
                } else {
                    tokenConstraints.append(view.autoConstrainAttribute(.Top, toAttribute: .Bottom, ofView: previousView!, withOffset: itemVerticalMargin, relation: .GreaterThanOrEqual))
                    currentX = leftOffset + viewWidth
                    intrinsicHeight += size.height + itemVerticalMargin
                    lineIndex++
                }
            } else {
                tokenConstraints.append(view.autoPinEdgeToSuperviewEdge(.Top, withInset: topPadding, relation: .Equal))
                tokenConstraints.append(view.autoPinEdgeToSuperviewEdge(.Leading, withInset: leftOffset, relation: .Equal))
                intrinsicHeight += size.height
                currentX += size.width
                if view is UITextField {
                    view.autoSetDimension(.Width, toSize: width - leftOffset)
                }
            }
            
            view.setNeedsUpdateConstraints()
            view.updateConstraintsIfNeeded()
            view.setNeedsLayout()
            view.layoutIfNeeded()
            
            previousView = view
        }
        intrinsicHeight += bottomPadding
        
        if contentViewHeightConstraint == nil {
            contentViewHeightConstraint = contentView.autoSetDimension(.Height, toSize: intrinsicHeight)
        } else {
            contentViewHeightConstraint!.constant = intrinsicHeight
        }
        invalidateIntrinsicContentSize()
    }
    
    override func intrinsicContentSize() -> CGSize {
        var height = intrinsicHeight
        if maxHeight != nil {
            height = maxHeight!
        }
        let size = CGSizeMake(UIViewNoIntrinsicMetric, height)
        println("intrinsicSize: \(size)")
        return size
    }
    
    // MARK: - Data Source Helpers
    
    private func titleForTokenAtIndex(index: UInt) -> String {
        return dataSource?.tokenField?(self, titleForTokenAtIndex: index) ?? String()
    }
    
    private func numberOfTokens() -> UInt {
        return dataSource?.numberOfTokensInTokenField?(self) ?? 0
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        layoutTokens()
    }
    
    override func isFirstResponder() -> Bool {
        return inputTextField?.isFirstResponder() ?? false
    }
    
    override func becomeFirstResponder() -> Bool {
        return inputTextField?.becomeFirstResponder() ?? false
    }
    
    override func resignFirstResponder() -> Bool {
        return inputTextField?.resignFirstResponder() ?? false
    }
    
    // MARK: - Targets
    
    func inputTextFieldDidChange(textField: UITextField) {
        delegate?.tokenField?(self, didChangeText: textField.text)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate?.tokenField?(self, didEnterText: textField.text)
        return false
    }
    
    // TODO add rest of textfield delegate
    
    // MARK: - Private Methods
    
    private func focusInputTextField() {
        // TODO should maybe account for the text input being the last line
        scrollView.setContentOffset(CGPointMake(0, intrinsicHeight - intrinsicContentSize().height), animated: false)
    }

}
