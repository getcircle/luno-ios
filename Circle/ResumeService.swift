//
//  ResumeService.swift
//  Circle
//
//  Created by Michael Hahn on 2/20/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension ResumeService {
    class Utils {
        
        class func formatPositionApproximateDate(position: ResumeService.Containers.Position) -> String {
            var formatted = String()
            if position.start_date.year != 0 {
                formatted += "\(position.start_date.year)"
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
