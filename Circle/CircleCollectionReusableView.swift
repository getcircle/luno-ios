//
//  CircleCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class CircleCollectionReusableView: UICollectionReusableView {

    class var classReuseIdentifier: String {
        return "CircleCollectionReusableView"
    }
    
    class var height: CGFloat {
        return 44.0
    }
}