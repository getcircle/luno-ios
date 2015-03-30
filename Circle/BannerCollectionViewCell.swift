//
//  BannerCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 3/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

enum BannerType: Int {
    case Anniversary
    case Birthday
    case NewHire
}

struct BannerNotifications {
    static let onBannerCTATappedNotification = "com.rhlabs.notification:onBannerCTATappedNotification"
    static let onBannerCloseTappedNotification = "com.rhlabs.notification:onBannerCloseTappedNotification"
}

class BannerCollectionViewCell : CircleCollectionViewCell {

    @IBOutlet weak private(set) var bannerTextLabel: UILabel!
    @IBOutlet weak private(set) var bannerCTAButton: UIButton!
    @IBOutlet weak private(set) var bannerCloseButton: UIButton!

    override class var classReuseIdentifier: String {
        return "BannerCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 120.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureBannerCloseButton()
        selectedBackgroundView = nil
    }

    // MARK: - Configuration
    
    private func configureBannerCloseButton() {
        bannerCloseButton.tintColor = UIColor.whiteColor()
        bannerCloseButton.convertToTemplateImageForState(.Normal)
    }
    
    override func setData(data: AnyObject) {
        if let bannerDictionary = data as? [String: AnyObject] {
            if let bannerType = BannerType(rawValue: (bannerDictionary["type"] as Int)) {
                switch bannerType {
                case .Anniversary:
                    if let profile = bannerDictionary["profile"] as? ProfileService.Containers.Profile {
                        bannerTextLabel.text = "It's " + profile.first_name + "'s Work Anniversary!"
                        bannerCTAButton.setCustomAttributedTitle(
                            "Say Congratulations".localizedUppercaseString(),
                            forState: .Normal
                        )
                        backgroundColor = UIColor.appWorkAnniversaryBannerBackground()
                        bannerCTAButton.backgroundColor = UIColor.appWorkAnniversaryBannerCTABackground()
                    }
                    break

                case .Birthday:
                    if let profile = bannerDictionary["profile"] as? ProfileService.Containers.Profile {
                        bannerTextLabel.text = "It's " + profile.first_name + "'s Birthday!"
                        bannerCTAButton.setCustomAttributedTitle(
                            "Wish Happy Birthday".localizedUppercaseString(),
                            forState: .Normal
                        )
                        backgroundColor = UIColor.appBirthdayBannerBackground()
                        bannerCTAButton.backgroundColor = UIColor.appBirthdayBannerCTABackground()
                    }
                    break
                    
                case .NewHire:
                    if let profile = bannerDictionary["profile"] as? ProfileService.Containers.Profile {
                        bannerTextLabel.text = profile.first_name + "'s new to the team!"
                        bannerCTAButton.setCustomAttributedTitle(
                            "Introduce yourself".localizedUppercaseString(),
                            forState: .Normal
                        )
                        backgroundColor = UIColor.appNewHireBannerBackground()
                        bannerCTAButton.backgroundColor = UIColor.appNewHireBannerCTABackground()
                    }
                    break
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func onBannerCTATapped(sender: AnyObject!) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            BannerNotifications.onBannerCTATappedNotification, 
            object: nil
        )
    }

    @IBAction func onBannerCloseTapped(sender: AnyObject!) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            BannerNotifications.onBannerCloseTappedNotification, 
            object: nil
        )
    }

}
