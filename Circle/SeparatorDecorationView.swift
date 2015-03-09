//
//  SeparatorDecorationView.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class SeparatorDecorationView: UICollectionReusableView {
    
    class var classReuseIdentifier: String {
        return "SeparatorDecorationView"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.appSeparatorViewColor()
        opaque = true
    }
}
