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

    struct TeamColorsHolder {
        static var colors = [String: UIColor]()
    }
    
    override class var classReuseIdentifier: String {
        return "TeamHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 200.0
    }
    
    @IBOutlet weak private(set) var teamNameLabel: UILabel!
    @IBOutlet weak private(set) var departmentNameLabel: UILabel!
    @IBOutlet weak private(set) var teamNameLabelCenterYConstraint: NSLayoutConstraint!
    
    private(set) var teamNameLabelCenterYConstraintInitialValue: CGFloat!
    private(set) var teamNameLabelInitialFontSize: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        teamNameLabelCenterYConstraintInitialValue = teamNameLabelCenterYConstraint.constant
        teamNameLabelInitialFontSize = teamNameLabel.font.pointSize
    }
    
    func setData(team: OrganizationService.Containers.Team) {
        teamNameLabel.attributedText = NSAttributedString(string: team.name.uppercaseString, attributes: [NSKernAttributeName: 2.0])
        teamNameLabel.layer.borderWidth = 0.0
        if team.name != team.department &&
            team.department.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" {
            departmentNameLabel.hidden = false
            departmentNameLabel.attributedText = NSAttributedString(string: team.department.uppercaseString, attributes: [NSKernAttributeName: 1.0])
        }
        else {
            departmentNameLabel.hidden = true
            // Move team name to the center if the department label is hidden
            teamNameLabelCenterYConstraint.constant = 0.0
            teamNameLabel.setNeedsUpdateConstraints()
            teamNameLabel.layoutIfNeeded()
            teamNameLabelCenterYConstraintInitialValue =  0.0
        }
        
        if let color = TeamColorsHolder.colors[team.id] {
            backgroundColor = color
        }
        else {
            let color = UIColor.teamHeaderBackgroundColor()
            TeamColorsHolder.colors[team.id] = color
            backgroundColor = color
        }
    }
}
