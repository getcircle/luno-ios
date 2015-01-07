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
    
    // NOTE: Because height is a computed class variable, it cannot be modifed
    // as per the size mode. This value is applicable only for the .Small
    // mode which is the default. So, the view controller should define
    // the height for this cell on thier own if not using the default mode.
    override class var height: CGFloat {
        return 48.0
    }
    
    @IBOutlet weak private(set) var nameLabel: UILabel!
    @IBOutlet weak private(set) var nameLabelTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var profileImageView: UIImageView!
    @IBOutlet weak private(set) var profileImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var subTextLabel: UILabel!
    
    // NOTE: The expected behavior here is to change mode just once
    var sizeMode: SizeMode = .Small {
        didSet {
            if oldValue != sizeMode {
                updateViewByMode()
            }
        }
    
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.makeItCircular(false)
    }

    override func setData(data: AnyObject) {
        if let profile = data as? ProfileService.Containers.Profile {
            nameLabel.text = profile.full_name
            subTextLabel.text = ["January 18th", "February 1st", "February 8th"][Int(arc4random()%3)]
            profileImageView.setImageWithProfile(profile)
        }
    }
    
    // MODE: - Sizing functions based on mode
    
    private func updateViewByMode() {
        switch sizeMode {
        case .Small:
            break
            
        case .Medium:
            nameLabel.font = UIFont(name: nameLabel.font.familyName, size: 17.0)
            nameLabelTopSpaceConstraint.constant = 12.0
            profileImageViewWidthConstraint.constant = 44.0
            profileImageView.layer.cornerRadiusWithMaskToBounds(22.0)
        }
    }
}
