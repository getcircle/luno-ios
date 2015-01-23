//
//  TeamGridItemCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 1/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TeamGridItemCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var teamBackgroundImageView: UIImageView!
    @IBOutlet weak private(set) var teamLabel: UILabel!
    @IBOutlet weak private(set) var teamNameLetterLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "TeamGridItemCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 155.0
    }

    override class var interItemSpacing: CGFloat {
        return 20.0
    }
    
    override class var lineSpacing: CGFloat {
        return 10.0
    }

    override class var width: CGFloat {
        return 120.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        teamBackgroundImageView.backgroundColor = UIColor.teamHeaderBackgroundColor()
        teamBackgroundImageView.makeItCircular(false)
    }

    override func setData(data: AnyObject) {
        if let team = data as? OrganizationService.Containers.Team {
            teamLabel.text = team.name
            teamNameLetterLabel.text = team.name[0]
        }
    }
}
