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
#if DEBUG
    let token = "2a286f40fa17ba573affa384378817a5"
#else
    let token = "62bae2b7a51edf77b99f470ec114324a"
#endif
    
        Mixpanel.sharedInstanceWithToken(token)
    }
}
