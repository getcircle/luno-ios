//
//  TagSuggestionCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 3/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TagSuggestionCollectionViewCell: UICollectionViewCell {
    
    var suggestedTag: Services.Profile.Containers.TagV1? {
        didSet {
            if suggestedTag!.hasId {
                tagSuggestionLabel.text = suggestedTag!.name
                tagSuggestionLabel.textColor = UIColor.appDefaultDarkTextColor()
            } else {
                tagSuggestionLabel.text = "add new tag \"\(suggestedTag!.name)\""
                tagSuggestionLabel.textColor = UIColor.appTintColor()
            }
        }
    }
    
    @IBOutlet private(set) weak var tagSuggestionLabel: UILabel!
    
    class var nib: UINib {
        return UINib(nibName: "TagSuggestionCollectionViewCell", bundle: nil)
    }

    class var classReuseIdentifier: String {
        return "TagSuggestionCollectionViewCell"
    }

}
