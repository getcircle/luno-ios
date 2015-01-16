//
//  TeamCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TeamCollectionViewCell: CircleCollectionViewCell {
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "TeamCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 48.0
    }
    
    override func setData(data: AnyObject) {
        if let team = data as? OrganizationService.Containers.Team {
            teamNameLabel.text = team.name
        }
    }

}
