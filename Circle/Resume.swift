//
//  Resume.swift
//  Circle
//
//  Created by Michael Hahn on 2/20/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension Services.Resume {
    class Utils {
        
        class func formatPositionApproximateDate(position: Services.Resume.Containers.PositionV1) -> String {
            var formatted = String()
            if position.startDate.year != 0 {
                formatted += "\(position.startDate.year)"
                if position.end_date.year != 0 || position.is_current {
                    formatted += " - "
                }
            }
            
            if position.end_date.year != 0 {
                formatted += "\(position.end_date.year)"
            } else if position.is_current {
                formatted += NSLocalizedString("Present", comment: "This position is currently held")
            }
            return formatted
        }
        
    }
}
