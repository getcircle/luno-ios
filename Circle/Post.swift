//
//  Post.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-10.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension Services.Post.Containers.PostV1 {

    func getFormattedChangedDate() -> String? {
        if changed.trimWhitespace() != "" {
            if let changedDate = NSDateFormatter.dateFromTimestampString(changed) {
                return changedDate.timeAgo()
            }
        }
        
        return nil
    }

}