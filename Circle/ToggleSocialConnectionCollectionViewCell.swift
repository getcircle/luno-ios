//
//  ToggleSocialConnectionCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 2/16/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

struct ToggleSocialConnectionCollectionViewCellNotifications {
    static let onProviderToggled = "com.circlehq.notification:onProviderToggledNotification"
}

class ToggleSocialConnectionCollectionViewCell: CircleCollectionViewCell {
    
    @IBOutlet weak var providerIconImageView: UIImageView!
    @IBOutlet weak var providerEmailLabel: UILabel!
    @IBOutlet weak var providerEnabledSwitch: UISwitch!
    
    override class var classReuseIdentifier: String {
        return "ToggleSocialConnectionCell"
    }
    
    private var identity: UserService.Containers.Identity?
    
    override func setData(data: AnyObject) {
        if let identity = data as? UserService.Containers.Identity {
            self.identity = identity
            switch identity.provider {
            case .Google:
                providerIconImageView.image = UIImage(named: "GooglePlus")
                providerIconImageView.tintColor = UIColor.googlePlusColor()
            case .Linkedin:
                providerIconImageView.image = UIImage(named: "LinkedIn")
                providerIconImageView.tintColor = UIColor.linkedinColor()
            default:
                providerIconImageView.hidden = true
            }
            providerEmailLabel.text = identity.email
            providerEnabledSwitch.setOn(true, animated: false)
            providerEnabledSwitch.addTarget(self, action: "socialSwitchToggled:", forControlEvents: .ValueChanged)
        }
    }
    
    func socialSwitchToggled(sender: AnyObject!) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            ToggleSocialConnectionCollectionViewCellNotifications.onProviderToggled,
            object: nil,
            userInfo: ["enable": providerEnabledSwitch.on, "identity": identity!]
        )
    }
    
}
