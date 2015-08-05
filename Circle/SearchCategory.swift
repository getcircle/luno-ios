//
//  SearchCategory.swift
//  Circle
//
//  Created by Ravi Rani on 7/30/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class SearchCategory: SearchSuggestion {
    
    enum Type: Int {
        case People = 1
        case Offices
        case Teams
    }
    
    var count: Int
    var type: Type
    
    init(categoryTitle: String, ofType: Type, withCount: Int, withImageSource : String) {
        type = ofType
        count = withCount
        super.init(title: categoryTitle, imageSource: withImageSource)
    }
    
    override func getTitle() -> String {
        return (title + " (" + String(count) + ")").uppercaseString
    }
}