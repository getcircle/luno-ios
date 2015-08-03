//
//  ProfileCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileCollectionViewCell: CircleCollectionViewCell {

    enum SizeMode {
        case Small
        case Medium
    }
    
    override class var classReuseIdentifier: String {
        return "ProfileCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 70.0
    }
    
    @IBOutlet weak private(set) var nameLabel: UILabel!
    @IBOutlet weak private(set) var profileImageView: CircleImageView!
    @IBOutlet weak private(set) var subTextLabel: UILabel!
    @IBOutlet weak private(set) var teamNameLetterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if !(self is ProfileGridItemCollectionViewCell) {
            profileImageView.makeItCircular()
        }
        nameLabel.font = UIFont.appPrimaryTextFont()
        subTextLabel.font = UIFont.appSecondaryTextFont()
        nameLabel.textColor = UIColor.appPrimaryTextColor()
        subTextLabel.textColor = UIColor.appSecondaryTextColor()
    }

    override func setData(data: AnyObject) {
        teamNameLetterLabel.hidden = true
        if let profile = data as? Services.Profile.Containers.ProfileV1 {
            setProfile(profile)
        }
        else if let team = data as? Services.Organization.Containers.TeamV1 {
            setTeam(team)
        }
        else if let location = data as? Services.Organization.Containers.LocationV1 {
            setLocation(location)
        }
    }
    
    private func setProfile(profile: Services.Profile.Containers.ProfileV1) {
        nameLabel.text = profile.fullName
        var subtitle = profile.title
        if let cardType = card?.type {
            switch card!.type {
            case .Birthdays:
                if let date = profile.birthDate.toDate() {
                    subtitle = NSDateFormatter.sharedBirthdayFormatter.stringFromDate(date)
                }
            case .Anniversaries:
                subtitle = getAnniversarySubtitle(profile)
                
            case .NewHires:
                if let date = profile.hireDate.toDate() {
                    subtitle = NSDateFormatter.stringFromDateWithStyles(date, dateStyle: .LongStyle, timeStyle: .NoStyle)
                }
            default:
                subtitle = profile.title
            }
        }
        subTextLabel.text = subtitle
        
        profileImageView.imageProfileIdentifier = profile.id
        profileImageView.makeItCircular()
        profileImageView.contentMode = .ScaleAspectFill
        profileImageView.setImageWithProfile(profile)
    }

    private func setTeam(team: Services.Organization.Containers.TeamV1) {
        nameLabel.text = team.name
        if team.profileCount == 0 && team.name != team.department {
            subTextLabel.text = team.department
        }
        else {
            subTextLabel.text = getCountLabel(team.profileCount)
        }
        teamNameLetterLabel.hidden = true

        profileImageView.imageText = ""
        profileImageView.removeRoundedCorners()
        profileImageView.contentMode = .Center
        profileImageView.image = UIImage(named: "Reports")
    }
    
    private func setLocation(location: Services.Organization.Containers.LocationV1) {
        nameLabel.text = location.address == nil ? location.name : location.address.officeName()
        subTextLabel.text = getCountLabel(location.profileCount)
        
        profileImageView.imageText = ""
        profileImageView.removeRoundedCorners()
        profileImageView.contentMode = .Center
        profileImageView.image = UIImage(named: "Location")
        teamNameLetterLabel.hidden = true
    }

    // MARK: - Helpers
    
    private func getAnniversarySubtitle(profile: Services.Profile.Containers.ProfileV1) -> String {
        var subtitle = ""
        if let hireDate = profile.hireDate.toDate() {
            let dateFormatter = NSDateFormatter.sharedAnniversaryFormatter
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            
            let dateString = dateFormatter.stringFromDate(hireDate)
            
            // calculate the upcoming anniversary to get the accurate number of years the anniversary represents
            let nowComponents = calendar?.components(.CalendarUnitYear, fromDate: NSDate())
            let upcomingAnniveraryComponents = calendar?.components(.CalendarUnitDay | .CalendarUnitMonth, fromDate: hireDate)
            upcomingAnniveraryComponents?.year = nowComponents!.year
            let upcomingAnniversary = calendar?.dateFromComponents(upcomingAnniveraryComponents!)
            
            let components = calendar?.components(
                .CalendarUnitYear,
                fromDate: hireDate,
                toDate: upcomingAnniversary!,
                options: .WrapComponents
            )
            if let years = components?.year {
                if years == 1 {
                    subtitle = "\(years) year - \(dateString)"
                } else {
                    subtitle = "\(years) years - \(dateString)"
                }
            }
        }
        return subtitle
    }
    
    private func getCountLabel(count: UInt32) -> String {
        var label = String(count)
        if count == 1 {
            label += " Person"
        } else {
            label += " People"
        }
        return label
    }
    
}
