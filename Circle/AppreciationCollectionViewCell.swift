//
//  AppreciationCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 2/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class AppreciationCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var appreciationTextLabel: UILabel!
    @IBOutlet weak private(set) var nameLabel: UILabel!
    @IBOutlet weak private(set) var profileImageView: CircleImageView!
    @IBOutlet weak private(set) var timestampLabel: UILabel!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "AppreciationCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 100.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        profileImageView.makeItCircular()
    }
    
    override func setData(data: AnyObject) {
        if let appreciation = data as? AppreciationService.Containers.Appreciation {
            appreciationTextLabel.text = appreciation.content

            if let gmtDate = NSDateFormatter.dateFromTimestampString(appreciation.created) {
                timestampLabel.text = NSDateFormatter.localizedRelativeDateString(gmtDate)
            }
        }
    }
    
    func setProfile(profile: ProfileService.Containers.Profile) {
        nameLabel.text = profile.full_name
        titleLabel.text = profile.title
        profileImageView.setImageWithProfile(profile)
    }
}
