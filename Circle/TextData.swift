//
//  TextData.swift
//  Circle
//
//  Created by Ravi Rani on 8/7/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class TextData {
    
    enum TextDataType {
        case LocationDescription
        case ProfileStatus
        case TeamDescription
        case TeamStatus
    }
    
    private(set) var value: String
    private(set) var editProfileId: String?
    private(set) var editedTimestamp: String?
    private(set) var type: TextDataType
    
    init(type withType: TextDataType, andValue: String) {
        type = withType
        value = andValue
    }
}