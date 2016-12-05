//
//  SearchSuggestion.swift
//  Circle
//
//  Created by Ravi Rani on 8/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class SearchSuggestion {
    var title: String
    var imageSource: String
    
    init(title suggestionTitle: String, imageSource withImageSource: String) {
        title = suggestionTitle
        imageSource = withImageSource
    }
    
    func getTitle() -> String {
        return title
    }
}