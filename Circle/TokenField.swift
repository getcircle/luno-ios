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
    optional func tokenFieldDidCancelEditing(tokenField: TokenField)
}

class TokenField: UIView,
    BackspaceTextFieldDelegate,
    TagTokenDelegate
{
    
    var tokenHeight: CGFloat = 35.0
    var dataSource: TokenFieldDataSource?
    var delegate: TokenFieldDelegate?
    var maxHeight: CGFloat?
    
    var tokenHighlightedBackgroundViewBackgroundColor = UIColor.appTintColor()
    var tokenHighlightedTokenTitleLabelTextColor = UIColor.whiteColor()
    var tokenHighlightedBorderColor = UIColor.appTagNormalBorderColor()
    var tokenBackgroundViewBackgroundColor = UIColor.appTagNormalBackgroundColor()
    var tokenTitleLabelTextColor = UIColor.appDefaultDarkTextColor()
    var tokenBorderColor = UIColor.appTagNormalBorderColor()
    var tokenTintColor = UIColor.appTintColor()
    var keyboardAppearance: UIKeyboardAppearance? {
        didSet {
            inputTextField?.keyboardAppearance = keyboardAppearance!
            invisibleTextField?.keyboardAppearance = keyboardAppearance!
        }
    }
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var contentViewHeightConstraint: NSLayoutConstraint?
    private var inputTextField: BackspaceTextField?
    private var invisibleTextField: BackspaceTextField?
    private var tokens = [TagToken]()
    
    private var tokenConstraints = [NSLayoutConstraint]()
    private var intrinsicHeight: CGFloat = 0.0
    private var updateConstraintsCalled = false
    
    init() {
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
        configureInvisibleTextField()
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView.newAutoLayoutView()
        scrollView.showsVerticalScrollIndicator = true
        addSubview(scrollView)
        UIView.autoSetIdentifier("ScrollView PinEdgesToSuperViewEdges", forConstraints: { () -> Void in
            self.scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            return
        })
    }
    
    private func configureContentView() {
        contentView = UIView.newAutoLayoutView()
        scrollView.addSubview(contentView)
        contentView.autoMatchDimension(.Width, toDimension: .Width, ofView: self).autoIdentify("ContentView Width")
        UIView.autoSetPriority(750, forConstraints: { () -> Void in
            self.contentView.autoSetContentCompressionResistancePriorityForAxis(.Vertical)
            self.contentView.autoSetContentCompressionResistancePriorityForAxis(.Horizontal)
        })
        UIView.autoSetIdentifier("ContentView PinEdgesToSuperViewEdges", forConstraints: { () -> Void in
            self.contentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            return
        })
    }
    
    private func configureInvisibleTextField() {
        invisibleTextField = BackspaceTextField.newAutoLayoutView()
        invisibleTextField!.autoSetDimensionsToSize(CGSizeZero)
        invisibleTextField!.delegate = self
        addSubview(invisibleTextField!)
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
        
        for view in contentView.subviews as! [UIView] {
            view.removeFromSuperview()
        }
        
        let leftPadding: CGFloat = 10.0
        tokens.removeAll(keepCapacity: true)
        for (var index: UInt = 0; index < numberOfTokens(); index++) {
            let title = titleForTokenAtIndex(index)
            let token = TagToken.newAutoLayoutView()
            token.setTitle(title)
            token.delegate = self
            contentView.addSubview(token)
            token.autoSetDimension(.Width, toSize: UIScreen.mainScreen().bounds.width - leftPadding, relation: .LessThanOrEqual)
            
            token.highlightedBackgroundViewBackgroundColor = tokenHighlightedBackgroundViewBackgroundColor
            token.highlightedTokenTitleLabelTextColor = tokenHighlightedTokenTitleLabelTextColor
            token.backgroundViewBackgroundColor = tokenBackgroundViewBackgroundColor
            token.titleLabelTextColor = tokenTitleLabelTextColor
            token.borderColor = tokenBorderColor
            // TODO have to trigger reconfiguring the colors of the elements, should move this to the didSet methods of the above properties
            token.highlighted = false
            tokens.append(token)
        }
        
        inputTextField = BackspaceTextField.newAutoLayoutView()
        if keyboardAppearance != nil {
            inputTextField?.keyboardAppearance = keyboardAppearance!
        }
        inputTextField?.textColor = tokenTitleLabelTextColor
        inputTextField?.tintColor = tokenTintColor
        inputTextField?.delegate = self
        contentView.addSubview(inputTextField!)
        inputTextField?.autoSetDimension(.Width, toSize: UIScreen.mainScreen().bounds.width - leftPadding, relation: .LessThanOrEqual)
        inputTextField?.autoSetDimension(.Width, toSize: 80.0, relation: .GreaterThanOrEqual)
        inputTextField?.autoSetDimension(.Height, toSize: tokenHeight)
        UIView.autoSetPriority(1000, forConstraints: { () -> Void in
            self.inputTextField?.autoSetContentCompressionResistancePriorityForAxis(.Horizontal)
            return
        })
        if invisibleTextField != nil && !invisibleTextField!.isFirstResponder() {
            inputTextField?.becomeFirstResponder()
        }
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
        for view in contentView.subviews as! [UIView] {
            let size = view.intrinsicContentSize()
            if previousView != nil {
                tokenConstraints.append(view.autoPinEdgeToSuperviewEdge(.Top, withInset: topPadding, relation: .GreaterThanOrEqual))
                tokenConstraints.append(view.autoPinEdgeToSuperviewEdge(.Leading, withInset: leftOffset, relation: .GreaterThanOrEqual))
                currentX += itemMargin
                var viewWidth = size.width
                if view is BackspaceTextField {
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
                if view is BackspaceTextField {
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
        invisibleTextField?.resignFirstResponder()
        tokens.map { $0.highlighted = false }
        return inputTextField?.becomeFirstResponder() ?? false
    }
    
    override func resignFirstResponder() -> Bool {
        // TODO resign invisible text field too
        if inputTextField != nil && inputTextField!.isFirstResponder() {
            return inputTextField!.resignFirstResponder()
        } else if invisibleTextField != nil && invisibleTextField!.isFirstResponder() {
            return invisibleTextField!.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - BackspaceTextFieldDelegate
    
    func textFieldShouldReturn(textField: BackspaceTextField) -> Bool {
        if textField.text != String() {
            delegate?.tokenField?(self, didEnterText: textField.text)
        }
        return false
    }

    func textFieldDidEnterBackspace(textField: BackspaceTextField) {
        var didDeleteToken = false
        for (index, token) in enumerate(tokens) {
            if token.highlighted {
                // TODO use Int instead of UInt
                delegate?.tokenField?(self, didDeleteTokenAtIndex: UInt(index))
                didDeleteToken = true
            }
        }
        
        if !didDeleteToken {
            if let token = tokens.last {
                token.highlighted = true
            }
        }
        if inputTextField != nil && inputTextField!.isFirstResponder() {
            inputTextField?.resignFirstResponder()
        }
        if invisibleTextField != nil && !invisibleTextField!.isFirstResponder() {
            invisibleTextField?.becomeFirstResponder()
        }
    }
    
    func textFieldDidChangeText(text: String) {
        if invisibleTextField != nil && invisibleTextField!.isFirstResponder() {
            invisibleTextField?.resignFirstResponder()
            invisibleTextField?.text = String()
            inputTextField?.text = text
            inputTextField?.becomeFirstResponder()
        }
        delegate?.tokenField?(self, didChangeText: text)
    }
    
    func textFieldDidBeginEditing(textField: BackspaceTextField) {
        if textField != invisibleTextField {
            tokens.map { $0.highlighted = false }
        }
        delegate?.tokenFieldDidBeginEditing?(self)
    }
    
    // MARK: - TagTokenDelegate
    
    func didTapToken(token: TagToken) {
        for item in tokens {
            if item == token {
                item.highlighted = !item.highlighted
            } else {
                item.highlighted = false
            }
        }
        setCursorVisibility()
    }
    
    // MARK: - Private Methods
    
    private func focusInputTextField() {
        var contentOffsetY: CGFloat = intrinsicHeight - frame.height
        if contentOffsetY < 0 {
            contentOffsetY = 0
        }
        scrollView.setContentOffset(CGPointMake(0, contentOffsetY), animated: false)
    }
    
    private func setCursorVisibility() {
        let highlightedTokens = tokens.filter { $0.highlighted }
        if highlightedTokens.count == 0 {
            becomeFirstResponder()
        } else {
            inputTextField?.text = String()
            inputTextField?.resignFirstResponder()
            delegate?.tokenFieldDidCancelEditing?(self)
            invisibleTextField?.becomeFirstResponder()
        }
    }

}
