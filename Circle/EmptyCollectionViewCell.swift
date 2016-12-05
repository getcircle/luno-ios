//
//  EmptyCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 3/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class EmptyCollectionViewCell: CircleCollectionViewCell {

    override class var classReuseIdentifier: String {
        return "EmptyCollectionViewCell"
    }
    
    override func setData(data: AnyObject) {}
}
