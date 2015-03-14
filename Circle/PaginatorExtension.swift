//
//  File.swift
//  Circle
//
//  Created by Michael Hahn on 3/13/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension Paginator {
    
    func countAsInt() -> Int {
        let value = String(count)
        return String(count).toInt() ?? 0
    }
    
}