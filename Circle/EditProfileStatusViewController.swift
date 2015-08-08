//
//  EditProfileStatusViewController.swift
//  Circle
//
//  Created by Ravi Rani on 8/7/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class EditProfileStatusViewController: TextInputViewController {

    var profile: Services.Profile.Containers.ProfileV1!

    override func assertRequiredData() {
        assert(profile != nil, "Profile should be set for this view controller")
    }
    
    override func getData() -> String? {
        if profile.hasStatus {
            return profile.status.value.trimWhitespace()
        }
        
        return nil
    }
    
    override func getViewTitle() -> String {
        return "Your Status"
    }
    
    override func getTextPlaceholder() -> String {
        return "What are you working on?"
    }
    
    override func saveData(data: String) {
        let statusBuilder: Services.Profile.Containers.ProfileStatusV1Builder
        if let status = profile.status {
            statusBuilder = status.toBuilder()
        }
        else {
            statusBuilder = Services.Profile.Containers.ProfileStatusV1Builder()
        }
        statusBuilder.value = data
        
        let profileBuilder = profile.toBuilder()
        profileBuilder.status = statusBuilder.build()
        Services.Profile.Actions.updateProfile(profileBuilder.build()) { (profile, error) -> Void in
            if let profile = profile {
                AuthViewController.updateUserProfile(profile)
            }
            
            self.onDataSaved()
        }
    }
}
