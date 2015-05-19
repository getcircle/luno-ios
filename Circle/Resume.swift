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
            if let startYear = position.startDate?.year where startYear != 0 {
                formatted += "\(startYear)"
                if let endYear = position.endDate?.year where endYear != 0 || position.isCurrent {
                    formatted += " - "
                }
            }
            
            if let endYear = position.endDate?.year where endYear != 0 {
                formatted += "\(endYear)"
            } else if position.isCurrent {
                formatted += NSLocalizedString("Present", comment: "This position is currently held")
            }
            return formatted
        }
        
    }
}
