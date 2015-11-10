//
//  ProfileCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

protocol ProfileCollectionViewCellDelegate {
    func onProfileAddButton(checked: Bool)
}

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
    
    var delegate: ProfileCollectionViewCellDelegate?
    
    @IBOutlet weak private(set) var nameLabel: UILabel!
    @IBOutlet weak private(set) var nameLabelRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var profileImageView: CircleImageView!
    @IBOutlet weak private(set) var subTextLabel: UILabel!
    @IBOutlet weak private(set) var teamNameLetterLabel: UILabel!
    @IBOutlet weak private(set) var addButton: UIButton!
    @IBOutlet weak private(set) var separatorView: UIView!
    @IBOutlet weak private(set) var disclosureIndicatorView: UIImageView! {
        didSet {
            disclosureIndicatorView.tintColor = UIColor.appIconColor()
        }
    }

    private var nameLabelRightConstraintInitialValue: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureAddButton()
        if !(self is ProfileGridItemCollectionViewCell) {
            profileImageView.makeItCircular()
        }
        nameLabel.font = UIFont.mainTextFont()
        subTextLabel.font = UIFont.secondaryTextFont()
        nameLabel.textColor = UIColor.appPrimaryTextColor()
        subTextLabel.textColor = UIColor.appSecondaryTextColor()
        nameLabelRightConstraintInitialValue = nameLabelRightConstraint.constant
    }

    // MARK: - Configuration
    
    private func configureAddButton() {
        addButton.addRoundCorners(radius: 4.0)
        separatorView.backgroundColor = UIColor.appSecondaryTextColor().colorWithAlphaComponent(0.3)
        addButton.layer.borderColor = UIColor.appSecondaryTextColor().CGColor
        addButton.layer.borderWidth = 1.0
        addButton.setImage(
            UIImage.imageFromColor(UIColor.appControlHighlightedColor(), withRect: addButton.frame),
            forState: .Highlighted
        )
        addButton.hidden = true
        separatorView.hidden = true
    }
    
    private func setAddButtonChecked(checked: Bool) {
        if checked {
            addButton.setImage(UIImage(named: "Check"), forState: .Normal)
        }
        else {
            addButton.setImage(nil, forState: .Normal)
        }
    }
    
    func supportAddButton(setChecked: Bool) {
        addButton.hidden = false
        separatorView.hidden = false
        nameLabelRightConstraint.constant = nameLabelRightConstraintInitialValue + 20 + addButton.frameWidth
        nameLabel.setNeedsUpdateConstraints()
        nameLabel.layoutIfNeeded()
        setAddButtonChecked(setChecked)
    }
    
    private func resetNameLabelConstraints() {
        if nameLabelRightConstraint.constant != nameLabelRightConstraintInitialValue {
            nameLabelRightConstraint.constant = nameLabelRightConstraintInitialValue
            nameLabel.setNeedsUpdateConstraints()
            nameLabel.layoutIfNeeded()
        }
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
        else if let post = data as? Services.Post.Containers.PostV1 {
            setPost(post)
        }
        
        addButton.hidden = true
        separatorView.hidden = true
        resetNameLabelConstraints()
    }
    
    private func setProfile(profile: Services.Profile.Containers.ProfileV1) {
        nameLabel.text = profile.fullName
        subTextLabel.text = profile.hasDisplayTitle ? profile.displayTitle : profile.title
        
        profileImageView.imageProfileIdentifier = profile.id
        profileImageView.makeItCircular()
        profileImageView.contentMode = .ScaleAspectFill
        profileImageView.setImageWithProfile(profile)
    }

    private func setTeam(team: Services.Organization.Containers.TeamV1) {
        nameLabel.text = team.getName()
        subTextLabel.text = team.getTeamCounts()
        teamNameLetterLabel.hidden = true

        profileImageView.imageProfileIdentifier = team.id
        profileImageView.makeItCircular(true, borderColor: UIColor.appIconBorderColor())
        profileImageView.contentMode = .Center
        profileImageView.image = UIImage(named: "detail_group")
    }
    
    private func setLocation(location: Services.Organization.Containers.LocationV1) {
        nameLabel.text = location.officeName()
        subTextLabel.text = location.cityRegion() + " (\(getCountLabel(location.profileCount)))"
        
        profileImageView.imageProfileIdentifier = location.id
        profileImageView.makeItCircular(true, borderColor: UIColor.appIconBorderColor())
        profileImageView.contentMode = .Center
        profileImageView.image = UIImage(named: "detail_office")
        teamNameLetterLabel.hidden = true
    }
    
    private func setPost(post: Services.Post.Containers.PostV1) {
        nameLabel.text = post.title
        if let formattedTimestamp = post.getFormattedChangedDate() {
            if let author = post.byProfile {
                subTextLabel.text = "\(author.fullName) - \(formattedTimestamp)"
            }
            else {
                subTextLabel.text = "Last edited \(formattedTimestamp)"
            }
        }
        
        profileImageView.imageProfileIdentifier = post.id
        profileImageView.makeItCircular(true, borderColor: UIColor.appIconBorderColor())
        profileImageView.contentMode = .Center
        profileImageView.image = UIImage(named: "detail_post")
        teamNameLetterLabel.hidden = true
    }

    // MARK: - Helpers
    
    private func getCountLabel(count: UInt32) -> String {
        var label = String(count)
        if count == 1 {
            label += " Person"
        } else {
            label += " People"
        }
        return label
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        // Toggle image
        let checked = addButton.imageForState(.Normal) == nil
        setAddButtonChecked(checked)
        delegate?.onProfileAddButton(checked)
    }
}
