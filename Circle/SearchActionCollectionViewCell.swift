//
//  SearchActionCollectionViewCell.swift
//  Luno
//
//  Created by Felix Mo on 2015-09-29.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit

class SearchActionCollectionViewCell: SearchSuggestionCollectionViewCell {

    override class var height: CGFloat {
        return 60.0
    }

    override class var classReuseIdentifier: String {
        return "SearchActionCollectionViewCell"
    }
}
