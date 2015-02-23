//
//  OfficeTeamManagerCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 2/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OfficeTeamManagerCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var managerImageView: CircleImageView!
    @IBOutlet weak private(set) var managerLabel: UILabel!
    @IBOutlet weak private(set) var managerButton: UIButton!

    @IBOutlet weak private(set) var officeImageView: CircleImageView!
    @IBOutlet weak private(set) var officeLabel: UILabel!
    @IBOutlet weak private(set) var officeButton: UIButton!

    @IBOutlet weak private(set) var spacer1: UIView!
    @IBOutlet weak private(set) var spacer2: UIView!
    
    @IBOutlet weak private(set) var teamImageView: CircleImageView!
    @IBOutlet weak private(set) var teamLabel: UILabel!
    @IBOutlet weak private(set) var teamNameLetterLabel: UILabel!
    @IBOutlet weak private(set) var teamButton: UIButton!

    override class var classReuseIdentifier: String {
        return "OfficeTeamManagerCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 165.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureImageViews()
        configureSpacerViews()
    }
    
    // MARK: - Configuration
    
    func configureImageViews() {
        for imageView in [officeImageView, teamImageView, managerImageView] {
            imageView.makeItCircular()
        }
    }
    
    func configureSpacerViews() {
        for spacer in [spacer1, spacer2] {
            spacer.backgroundColor = UIColor.viewBackgroundColor()
        }
    }
    
    // MARK: - Set Data
    
    override func setData(data: AnyObject) {
        if let dataDictionary = data as? [String: AnyObject] {
            if let team = dataDictionary["team"] as? OrganizationService.Containers.Team {
                teamImageView.backgroundColor = UIColor.teamHeaderBackgroundColor(team.id)
                teamLabel.text = team.name
                teamNameLetterLabel.text = team.name[0]
            }
            
            if let manager = dataDictionary["manager"] as? ProfileService.Containers.Profile {
                managerImageView.setImageWithProfile(manager)
                managerLabel.text = manager.first_name + " " + manager.last_name[0] + "."
                showManagerInfo()
            }
            else {
                hideManagerInfo()
            }
            
            if let office = dataDictionary["office"] as? OrganizationService.Containers.Address {
                // TODO: Make this come from the backend
                officeImageView.image = UIImage(named: "SF")
                officeLabel.text = office.name
            }
        }
    }
    
    // MARK: - Hide/Show Manager
    
    func hideManagerInfo() {
        for view in [managerImageView, managerLabel, managerButton] {
            view.alpha = 0.0
        }
        
        spacer2.alpha = 0.0
    }
    
    func showManagerInfo() {
        for view in [managerImageView, managerLabel, managerButton] {
            view.alpha = 1.0
        }
        
        spacer2.alpha = 1.0
    }
}
