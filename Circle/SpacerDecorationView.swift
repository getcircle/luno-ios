//
//  SpacerDecorationView.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class SpacerDecorationView: UICollectionReusableView {
    class var kind: String {
        return "SpacerDecorationView"
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
        self.backgroundColor = UIColor.viewBackgroundColor()
        self.opaque = true
    }
}
