//
//  SearchCategory.swift
//  Circle
//
//  Created by Ravi Rani on 7/30/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class SearchCategory {
    
    enum TileType: Int {
        case People = 1
        case Offices
        case Teams
    }
    
    private(set) var title: String
    var count: Int
    var imageSource: String
    var type: TileType
    
    init(categoryTitle: String, ofType: TileType, withCount: Int, withImageSource : String) {
        title = categoryTitle
        type = ofType
        count = withCount
        imageSource = withImageSource
    }
}