//
//  CircleActivityIndicatorView.swift
//  Circle
//
//  Created by Ravi Rani on 3/26/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class CircleActivityIndicatorView: UIImageView {

    var hidesWhenStopped: Bool = false

    class var height: CGFloat {
        return 40.0
    }
    
    class var width: CGFloat {
        return 40.0
    }

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
        var animatedImages = [UIImage]()
        
        for i in 0...58 {
            let imageName = "Loader_000" + (i <= 9 ? "0" : "") + String(i)
            animatedImages.append(
                UIImage(named: imageName)!.imageWithRenderingMode(.AlwaysTemplate)
            )
        }

        frame = CGRectMake(0.0, 0.0, self.dynamicType.width, self.dynamicType.height)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        animationImages = animatedImages
    }
    
    override func startAnimating() {
        super.startAnimating()
        hidden = false
    }
    
    override func stopAnimating() {
        super.stopAnimating()
        
        if hidesWhenStopped {
            hidden = true
        }
    }
}
