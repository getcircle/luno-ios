//
//  EditTeamDescriptionViewController.swift
//  Circle
//
//  Created by Ravi Rani on 8/7/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class EditTeamDescriptionViewController: TextInputViewController {
    
    var team: Services.Organization.Containers.TeamV1!
    
    override func assertRequiredData() {
        assert(team != nil, "Team should be set for this view controller")
    }
    
    override func getData() -> String? {
        if team.hasDescription {
            return team.description_.trimWhitespace()
        }
        
        return nil
    }
    
    override func getViewTitle() -> String {
        return "Team Description"
    }
    
    override func getTextPlaceholder() -> String {
        return "Add your team description here. Its best to add your team's mission statement or high level goals, and how your team impacts the business."
    }
    
    override func saveData(data: String) {
        let teamBuilder = team.toBuilder()
        teamBuilder.description_ = data
        Services.Organization.Actions.updateTeam(teamBuilder.build()) { (team, error) -> Void in
            self.onDataSaved()
        }
    }
}
