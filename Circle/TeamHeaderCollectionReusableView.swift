//
//  TeamHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/17/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TeamHeaderCollectionReusableView: DetailHeaderCollectionReusableView {

    override class var classReuseIdentifier: String {
        return "TeamHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 200.0
    }
    
    @IBOutlet weak private(set) var teamNameLabel: UILabel!
    @IBOutlet weak private(set) var subTitleLabel: UILabel!
    @IBOutlet weak private(set) var teamNameLabelCenterYConstraint: NSLayoutConstraint!
    
    private(set) var teamNameLabelCenterYConstraintInitialValue: CGFloat!
    private(set) var teamNameLabelInitialFontSize: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        teamNameLabelCenterYConstraintInitialValue = teamNameLabelCenterYConstraint.constant
        teamNameLabelInitialFontSize = teamNameLabel.font.pointSize
    }
    
    func setData(team: Services.Organization.Containers.TeamV1) {
        teamNameLabel.attributedText = NSAttributedString(
            string: team.name.uppercaseString, 
            attributes: [NSKernAttributeName: 2.0]
        )
        teamNameLabel.layer.borderWidth = 0.0
        subTitleLabel.hidden = false
        subTitleLabel.attributedText = NSAttributedString(
            string: team.getTeamCounts().uppercaseString,
            attributes: [NSKernAttributeName: 1.0]
        )
        backgroundColor = UIColor.appTeamHeaderBackgroundColor(team)
    }
}
