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
        
        profileImageView.makeItCircular()
        nameLabel.font = UIFont.appPrimaryTextFont()
        subTextLabel.font = UIFont.appSecondaryTextFont()
        nameLabel.textColor = UIColor.appPrimaryTextColor()
        subTextLabel.textColor = UIColor.appSecondaryTextColor()
    }

    override func setData(data: AnyObject) {
        teamNameLetterLabel.hidden = true
        if let profile = data as? ProfileService.Containers.Profile {
            setProfile(profile)
        }
        else if let team = data as? OrganizationService.Containers.Team {
            setTeam(team)
        }
        else if let location = data as? OrganizationService.Containers.Location {
            setLocation(location)
        }
    }
    
    private func setProfile(profile: ProfileService.Containers.Profile) {
        nameLabel.text = profile.full_name
        var subtitle = profile.title
        if let cardType = card?.type {
            switch card!.type {
            case .Birthdays:
                if let date = profile.birth_date.toDate() {
                    subtitle = NSDateFormatter.sharedBirthdayFormatter.stringFromDate(date)
                }
            case .Anniversaries:
                subtitle = getAnniversarySubtitle(profile)
                
            case .NewHires:
                if let date = profile.hire_date.toDate() {
                    subtitle = NSDateFormatter.stringFromDateWithStyles(date, dateStyle: .LongStyle, timeStyle: .NoStyle)
                }
            default:
                subtitle = profile.title
            }
        }
        subTextLabel.text = subtitle
        profileImageView.imageProfileIdentifier = profile.id
        profileImageView.setImageWithProfile(profile)
    }

    private func setTeam(team: OrganizationService.Containers.Team) {
        profileImageView.imageText = ""
        profileImageView.backgroundColor = UIColor.appTeamHeaderBackgroundColor(team.id)
        profileImageView.image = nil
        nameLabel.text = team.name
        subTextLabel.text = getCountLabel(team.profile_count)
        teamNameLetterLabel.text = team.name[0]
        teamNameLetterLabel.hidden = false
    }
    
    private func setLocation(location: OrganizationService.Containers.Location) {
        nameLabel.text = location.address.officeName()
        profileImageView.imageText = ""
        profileImageView.image = UIImage(named: "SF")
        subTextLabel.text = getCountLabel(location.profile_count)
    }

    // MARK: - Helpers
    
    private func getAnniversarySubtitle(profile: ProfileService.Containers.Profile) -> String {
        var subtitle = ""
        if let hireDate = profile.hire_date.toDate() {
            let dateFormatter = NSDateFormatter.sharedAnniversaryFormatter
            let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
            
            let dateString = dateFormatter.stringFromDate(hireDate)
            
            // calculate the upcoming anniversary to get the accurate number of years the anniversary represents
            let nowComponents = calendar?.components(.YearCalendarUnit, fromDate: NSDate())
            let upcomingAnniveraryComponents = calendar?.components(.DayCalendarUnit | .MonthCalendarUnit, fromDate: hireDate)
            upcomingAnniveraryComponents?.year = nowComponents!.year
            let upcomingAnniversary = calendar?.dateFromComponents(upcomingAnniveraryComponents!)
            
            let components = calendar?.components(
                .YearCalendarUnit,
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
