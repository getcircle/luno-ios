//
//  OfficeTeamManagerCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 2/21/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

struct OfficeTeamManagerNotifications {
    static let onManagerTappedNotification = "com.ravcode.notification:onManagerTappedNotification"
    static let onOfficeTappedNotification = "com.ravcode.notification:onOfficeTappedNotification"
    static let onTeamTappedNotification = "com.ravcode.notification:onTeamTappedNotification"
}

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
        selectedBackgroundView = nil
        configureImageViews()
        configureSpacerViews()
        configureButtons()
    }
    
    // MARK: - Configuration
    
    private func configureImageViews() {
        for imageView in [officeImageView, teamImageView, managerImageView] {
            imageView.makeItCircular()
        }
    }
    
    private func configureSpacerViews() {
        for spacer in [spacer1, spacer2] {
            spacer.backgroundColor = UIColor.appViewBackgroundColor()
        }
    }
    
    private func configureButtons() {
        for button in [officeButton, teamButton, managerButton] {
            button.setImage(
                UIImage.imageFromColor(UIColor.appControlHighlightedColor() , withRect: button.bounds),
                forState: .Highlighted
            )
        }
    }

    // MARK: - Set Data
    
    override func setData(data: AnyObject) {
        if let dataDictionary = data as? [String: AnyObject] {
            if let team = dataDictionary["team"] as? OrganizationService.Containers.Team {
                teamImageView.backgroundColor = UIColor.appTeamHeaderBackgroundColor(team.id)
                teamLabel.text = team.name
                teamNameLetterLabel.text = team.name[0]
            }
            
            if let manager = dataDictionary["manager"] as? ProfileService.Containers.Profile {
                if manager.hasFirstName {
                    managerImageView.setImageWithProfile(manager)
                    managerLabel.text = manager.full_name
                    showManagerInfo()
                }
                else {
                    hideManagerInfo()
                }
            }
            else {
                hideManagerInfo()
            }
            
            if let office = dataDictionary["office"] as? OrganizationService.Containers.Location {
                // TODO: Make this come from the backend
                officeImageView.image = UIImage(named: "SF")
                officeLabel.text = office.address.officeName()
            }
        }
    }
    
    // MARK: - Hide/Show Manager
    
    private func hideManagerInfo() {
        for view in [managerImageView, managerLabel, managerButton] {
            view.alpha = 0.0
        }
        
        spacer2.alpha = 0.0
    }
    
    private func showManagerInfo() {
        for view in [managerImageView, managerLabel, managerButton] {
            view.alpha = 1.0
        }
        
        spacer2.alpha = 1.0
    }
    
    // MARK: - IBActions

    @IBAction func onManagerButtonTapped(sender: AnyObject!) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            OfficeTeamManagerNotifications.onManagerTappedNotification, 
            object: nil
        )
    }

    @IBAction func onOfficeButtonTapped(sender: AnyObject!) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            OfficeTeamManagerNotifications.onOfficeTappedNotification,
            object: nil
        )
    }

    @IBAction func onTeamButtonTapped(sender: AnyObject!) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            OfficeTeamManagerNotifications.onTeamTappedNotification,
            object: nil
        )
    }
}
