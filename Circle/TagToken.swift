//
//  TagToken.swift
//  Circle
//
//  Created by Michael Hahn on 4/2/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

private let TagTokenHeight: CGFloat = 35.0

class TagToken: UIView {
    
    private var backgroundView: UIView!
    private var titleLabel: PaddedLabel!
    
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
        configureBackgroundView()
        configureTitleLabel()
    }
    
    // MARK: - Configuration
    
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
        backgroundView.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(titleLabel.intrinsicContentSize().width, TagTokenHeight)
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
}