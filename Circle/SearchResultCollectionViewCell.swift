//
//  SearchResultCollectionViewCell.swift
//  Luno
//
//  Created by Felix Mo on 2015-09-28.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SearchResultCollectionViewCell: ProfileCollectionViewCell {

    override class var classReuseIdentifier: String {
        return "SearchResultCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 60.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.makeItCircular()
        nameLabel.font = UIFont.regularFont(16.0)
        subTextLabel.font = UIFont.secondaryTextFont()
        nameLabel.textColor = UIColor.appPrimaryTextColor()
        subTextLabel.textColor = UIColor.appSecondaryTextColor()
    }
    
    override func setData(data: AnyObject) {
        if let profileStatus = data as? Services.Profile.Containers.ProfileStatusV1 {
            setProfileStatus(profileStatus)
        }
        
        super.setData(data)
    }
    
    private func setProfileStatus(status: Services.Profile.Containers.ProfileStatusV1) {
        let statusText = status.value
        nameLabel.text = statusText
        subTextLabel.text = status.profile.fullName + ", " + TextData.getFormattedTimestamp(status.changed, authorProfile: nil, addHyphen: false)!
        teamNameLetterLabel.hidden = true
        
        profileImageView.imageProfileIdentifier = status.id
        profileImageView.makeItCircular(true, borderColor: UIColor.appIconBorderColor())
        profileImageView.contentMode = .Center
        profileImageView.image = UIImage(named: "detail_quote")?.imageWithRenderingMode(.AlwaysTemplate)
        profileImageView.tintColor = UIColor(red: 66, green: 66, blue: 66)
    }
}
