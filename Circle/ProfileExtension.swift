//
//  ProfileExtension.swift
//  Circle
//
//  Created by Ravi Rani on 3/31/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension ProfileService.Containers.Profile {

    func nameWithNickName() -> String {
        var fullNameWithNickname = first_name
        
        if hasNickname && nickname.trimWhitespace() != "" {
            fullNameWithNickname += " (" + nickname + ")"
        }
        fullNameWithNickname += " " + last_name
        return fullNameWithNickname
    }
}