//
//  ProfileExtension.swift
//  Circle
//
//  Created by Ravi Rani on 3/31/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension Services.Profile.Containers.ProfileV1 {

    func nameWithNickName() -> String {
        var fullNameWithNickname = firstName
        
        if hasNickname && nickname.trimWhitespace() != "" {
            fullNameWithNickname += " (" + nickname + ")"
        }
        fullNameWithNickname += " " + lastName
        return fullNameWithNickname
    }
}
