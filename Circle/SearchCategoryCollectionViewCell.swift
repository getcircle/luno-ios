//
//  SearchCategoryCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 3/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class SearchCategoryCollectionViewCell: CircleCollectionViewCell {
        
    override class var height: CGFloat {
        return 50.0
    }

    @IBOutlet weak private(set) var imageView: UIImageView!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "SearchCategoryCollectionViewCell"
    }
    
    override func setData(data: AnyObject) {
        if let searchCategory = data as? SearchCategory {
            titleLabel.text = (searchCategory.title + " (" + String(searchCategory.count) + ")").uppercaseString
            imageView.image = UIImage(named: searchCategory.imageSource)
        }
    }
}
