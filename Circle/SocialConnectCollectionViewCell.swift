//
//  SocialConnectCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 2/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

struct SocialConnectCollectionViewCellNotifications {
    static let onCTATappedNotification = "com.rhlabs.notification:onSocialConnectCTATappedNotification"
}

class SocialConnectCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var socialConnectCTA: UIButton!
    
    override class var classReuseIdentifier: String {
        return "SocialConnectCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 70.0
    }
    
    private var CTAContentType: ContentType?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        CTAContentType = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        socialConnectCTA.addRoundCorners(radius: 2.0)
        selectedBackgroundView = nil
    }
    
    override func setData(data: AnyObject) {
        if let keyValueDictionary = data as? [String: AnyObject] {
            socialConnectCTA.setCustomAttributedTitle(keyValueDictionary["title"] as! String!, forState: .Normal)
            
            if let typeOfCTA = keyValueDictionary["type"] as? Int {
                CTAContentType = ContentType(rawValue: typeOfCTA)
                switch CTAContentType! {
                case .LinkedInConnect:
                    socialConnectCTA.backgroundColor = UIColor.appLinkedinConnectCTABackgroundColor()
                    break
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func socialConnectCTATapped(sender: AnyObject) {
        if let typeOfCTA = CTAContentType {
            NSNotificationCenter.defaultCenter().postNotificationName(
                SocialConnectCollectionViewCellNotifications.onCTATappedNotification,
                object: nil,
                userInfo: ["type": typeOfCTA.rawValue]
            )
        }
    }
}
