//
//  KeyValueData.swift
//  Circle
//
//  Created by Ravi Rani on 8/6/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class KeyValueData {

    private(set) var title: String
    private(set) var value: String
    private(set) var type: ContentType
    var isTappable = false
    
    init(type dataType: ContentType, title withTitle: String, value andValue: String) {
        type = dataType
        title = withTitle
        value = andValue
    }
}
