//
//  EditTeamStatusViewController.swift
//  Circle
//
//  Created by Ravi Rani on 8/7/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class EditTeamStatusViewController: TextInputViewController {

    var team: Services.Organization.Containers.TeamV1!

    override func assertRequiredData() {
        assert(team != nil, "Team should be set for this view controller")
    }
    
    override func getData() -> String? {
        if team.hasStatus {
            return team.status.value.trimWhitespace()
        }
        
        return nil
    }
    
    override func getViewTitle() -> String {
        return "Team Status"
    }
    
    override func getTextPlaceholder() -> String {
        return "What is your team working on?"
    }
    
    override func saveData(data: String) {
        let statusBuilder: Services.Organization.Containers.TeamStatusV1Builder
        if let status = team.status {
            statusBuilder = status.toBuilder()
        }
        else {
            statusBuilder = Services.Organization.Containers.TeamStatusV1Builder()
        }
        statusBuilder.value = data
        
        let teamBuilder = team.toBuilder()
        teamBuilder.status = statusBuilder.build()
        Services.Organization.Actions.updateTeam(teamBuilder.build()) { (team, error) -> Void in
            self.onDataSaved(team)
        }
    }
}