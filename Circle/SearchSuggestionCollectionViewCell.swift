//
//  SearchSuggestionCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 3/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class SearchSuggestionCollectionViewCell: CircleCollectionViewCell {
        
    override class var height: CGFloat {
        return 50.0
    }

    @IBOutlet weak private(set) var imageView: UIImageView!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "SearchSuggestionCollectionViewCell"
    }
    
    override func setData(data: AnyObject) {
        if let searchSuggestion = data as? SearchSuggestion {
            titleLabel.text = searchSuggestion.getTitle()
            imageView.image = UIImage(named: searchSuggestion.imageSource)?.imageWithRenderingMode(.AlwaysTemplate)
            imageView.tintColor = UIColor(red: 120, green: 120, blue: 120)
        }
    }
}
