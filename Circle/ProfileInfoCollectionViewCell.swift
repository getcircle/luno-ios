//
//  ProfileInfoCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 8/17/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileInfoCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet private(set) weak var timeLabel: UILabel!
    @IBOutlet private(set) weak var timeImageView: UIImageView!
    @IBOutlet private(set) weak var locationLabel: UILabel!
    @IBOutlet private(set) weak var locationImageView: UIImageView!
    
    override class var classReuseIdentifier: String {
        return "ProfileInfoCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 50.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        resetViews()
        configureLabels()
    }

    // MARK: - Reset
    
    private func resetViews() {
        timeLabel.text = ""
        locationLabel.text = ""
    }
    
    private func configureLabels() {
        timeLabel.textColor = UIColor.appPrimaryTextColor()
        timeLabel.font = UIFont.appPrimaryTextFont()
        locationLabel.textColor = UIColor.appPrimaryTextColor()
        locationLabel.font = UIFont.appPrimaryTextFont()
    }
    
    override func setData(data: AnyObject) {
        if let location = data as? Services.Organization.Containers.LocationV1 {
            locationLabel.text = location.cityRegion()
            timeLabel.text = location.officeCurrentTimeLabel(nil)
            if let indicatorImage = location.officeDaylightIndicator() {
                timeImageView.image = indicatorImage
                timeImageView.tintColor = timeLabel.textColor
            }
            else {
                timeImageView.image = UIImage(named: "Clock")
            }
        }
    }
}
