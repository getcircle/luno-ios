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
        
        static func formatPositionApproximateDate(position: Services.Resume.Containers.PositionV1) -> String {
            var formatted = String()
            if position.hasStartDate && position.startDate.year != 0 {
                formatted += "\(position.startDate.year)"
                if (position.hasEndDate && position.endDate.year != 0) || position.isCurrent {
                    formatted += " - "
                }
            }
            
            if position.hasEndDate && position.endDate.year != 0 {
                formatted += "\(position.endDate.year)"
            } else if position.isCurrent {
                formatted += NSLocalizedString("Present", comment: "This position is currently held")
            }
            return formatted
        }
        
    }
}
