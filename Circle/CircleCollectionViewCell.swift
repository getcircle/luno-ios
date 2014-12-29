//
//  CircleCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class CircleCollectionViewCell: UICollectionViewCell {

    class var classReuseIdentifier: String {
        return "CircleCollectionViewCell"
    }
    
    class var height: CGFloat {
        return 44.0
    }
    
    func setData(data: AnyObject) {
        fatalError("Subclasses need to override this and add specific data types")
    }
}
