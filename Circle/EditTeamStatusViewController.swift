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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.keyboardType = .Twitter
    }

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
    
    override func saveData(data: String) throws {
        let statusBuilder: Services.Organization.Containers.TeamStatusV1.Builder
        if let status = team.status {
            statusBuilder = try status.toBuilder()
        }
        else {
            statusBuilder = Services.Organization.Containers.TeamStatusV1.Builder()
        }
        statusBuilder.value = data
        
        let teamBuilder = try team.toBuilder()
        teamBuilder.status = try statusBuilder.build()
        Services.Organization.Actions.updateTeam(try teamBuilder.build()) { (team, error) -> Void in
            if let team = team {
                Tracker.sharedInstance.trackTeamUpdate(team.id, fields: ["status"])
            }
            self.onDataSaved(team)
        }
    }
}