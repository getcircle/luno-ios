//
//  DebugUtils.swift
//  Circle
//
//  Created by Ravi Rani on 3/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class DebugUtils {

    static func measure(title: String!, call: () -> Void) {
        let startTime = CACurrentMediaTime()
        call()
        let endTime = CACurrentMediaTime()
        if let title = title {
            print("\(title): ", terminator: "")
        }
        print("Time - \(endTime - startTime)")
    }

}
