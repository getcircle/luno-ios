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
    static let onProviderToggled = "com.lunohq.notification:onProviderToggledNotification"
}

class ToggleSocialConnectionCollectionViewCell: CircleCollectionViewCell {
    
    @IBOutlet weak var providerIconImageView: UIImageView!
    @IBOutlet weak var providerEmailLabel: UILabel!
    @IBOutlet weak var providerEnabledSwitch: UISwitch!
    
    override class var classReuseIdentifier: String {
        return "ToggleSocialConnectionCollectionViewCell"
    }
    
    private var identity: Services.User.Containers.IdentityV1?
    
    override func setData(data: AnyObject) {
        if let identity = data as? Services.User.Containers.IdentityV1 {
            self.identity = identity
            switch identity.provider {
            case .Google:
                providerIconImageView.image = UIImage(named: "GooglePlus")?.templateImage()
                providerIconImageView.tintColor = UIColor.googlePlusColor()
            case .Linkedin:
                providerIconImageView.image = UIImage(named: "LinkedIn")?.templateImage()
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
