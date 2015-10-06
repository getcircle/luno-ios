//
//  Mixpanel.swift
//  Circle
//
//  Created by Michael Hahn on 2/12/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import Mixpanel
import ProtobufRegistry

extension Mixpanel {
    static func setup() {
        Mixpanel.sharedInstanceWithToken("2a286f40fa17ba573affa384378817a5")
    }
}
