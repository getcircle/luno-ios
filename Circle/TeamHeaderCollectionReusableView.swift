//
//  TeamHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/17/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TeamHeaderCollectionReusableView: CircleCollectionReusableView {

    override class var classReuseIdentifier: String {
        return "TeamHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 200.0
    }
    
    @IBOutlet weak private(set) var teamNameLabel: UILabel!
    @IBOutlet weak private(set) var departmentNameLabel: UILabel!
    @IBOutlet weak private(set) var teamNameLabelCenterYConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        addVisualEffectView(.Dark)
    }
    
    func setData(team: OrganizationService.Containers.Team) {
        teamNameLabel.attributedText = NSAttributedString(string: team.name.uppercaseString, attributes: [NSKernAttributeName: 2.0])
        teamNameLabel.layer.borderWidth = 0.0
        if team.name != team.department {
            departmentNameLabel.hidden = false
            departmentNameLabel.attributedText = NSAttributedString(string: team.department.uppercaseString, attributes: [NSKernAttributeName: 1.0])
        }
        else {
            departmentNameLabel.hidden = true
        }
        
        backgroundColor = UIColor.teamHeaderBackgroundColor()
    }
}
