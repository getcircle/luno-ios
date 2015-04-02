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
    
    var delegate: TagTokenDelegate?
    var highlighted: Bool = false {
        didSet {
            if highlighted {
                backgroundView.backgroundColor = UIColor.appTintColor()
                titleLabel.textColor = UIColor.whiteColor()
            } else {
                backgroundView.backgroundColor = UIColor.appTagNormalBackgroundColor()
                titleLabel.textColor = UIColor.appDefaultDarkTextColor()
            }
        }
    }
    private var backgroundView: UIView!
    private var titleLabel: PaddedLabel!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
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
        configureView()
        configureBackgroundView()
        configureTitleLabel()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapToken:")
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureBackgroundView() {
        backgroundView = UIView.newAutoLayoutView()
        backgroundView.backgroundColor = UIColor.appTagNormalBackgroundColor()
        backgroundView.layer.borderColor = UIColor.appTagNormalBorderColor().CGColor
        backgroundView.layer.borderWidth = 1.0
        addSubview(backgroundView)
        backgroundView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    private func configureTitleLabel() {
        titleLabel = PaddedLabel.newAutoLayoutView()
        titleLabel.paddingEdgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
        titleLabel.textColor = UIColor.appDefaultDarkTextColor()
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