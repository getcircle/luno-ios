//
//  TagToken.swift
//  Circle
//
//  Created by Michael Hahn on 4/2/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

private let TagTokenHeight: CGFloat = 35.0

protocol TagTokenDelegate {
    func didTapToken(token: TagToken)
}

class TagToken: UIView {
    
    var highlightedBackgroundViewBackgroundColor = UIColor.appTintColor()
    var highlightedTokenTitleLabelTextColor = UIColor.whiteColor()
    var highlightedBorderColor = UIColor.appTagNormalBorderColor()
    var backgroundViewBackgroundColor = UIColor.appTagNormalBackgroundColor()
    var titleLabelTextColor = UIColor.appDefaultDarkTextColor()
    var borderColor = UIColor.appTagNormalBorderColor()
    
    var delegate: TagTokenDelegate?
    var highlighted: Bool = false {
        didSet {
            if highlighted {
                backgroundView.backgroundColor = highlightedBackgroundViewBackgroundColor
                titleLabel.textColor = highlightedTokenTitleLabelTextColor
                layer.borderColor = highlightedBorderColor.CGColor
            } else {
                backgroundView.backgroundColor = backgroundViewBackgroundColor
                titleLabel.textColor = titleLabelTextColor
                layer.borderColor = borderColor.CGColor
            }
        }
    }
    private var backgroundView: UIView!
    private var titleLabel: PaddedLabel!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    init() {
        super.init(frame: CGRectZero)
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
        configureView()
        configureBackgroundView()
        configureTitleLabel()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapToken:")
        addGestureRecognizer(tapGestureRecognizer)
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = 1.0
    }
    
    private func configureBackgroundView() {
        backgroundView = UIView.newAutoLayoutView()
        backgroundView.backgroundColor = backgroundViewBackgroundColor
        addSubview(backgroundView)
        backgroundView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    private func configureTitleLabel() {
        titleLabel = PaddedLabel.newAutoLayoutView()
        titleLabel.paddingEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
        titleLabel.textColor = titleLabelTextColor
        titleLabel.font = UIFont.appTagTokenFont()
        backgroundView.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(titleLabel.intrinsicContentSize().width, TagTokenHeight)
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    // MARK: - Targets
    
    func didTapToken(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapToken(self)
    }
    
}
