//
//  ProfileHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileHeaderCollectionReusableView: CircleCollectionReusableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameNavLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!

    private var visualEffectView: UIVisualEffectView!
    
    override class var classReuseIdentifier: String {
        return "ProfileHeaderView"
    }
    
    override class var height: CGFloat {
        return 200.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        let blurEffect = UIBlurEffect(style: .Dark)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        visualEffectView.frame = backgroundImage.frame
        insertSubview(visualEffectView, aboveSubview: backgroundImage)
        visualEffectView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        profileImage.makeItCircular(true)
        nameNavLabel.alpha = 0.0
    }
    
    func setProfile(profile: ProfileService.Containers.Profile) {
        nameLabel.text = profile.first_name + " " + profile.last_name
        nameNavLabel.text = nameLabel.text
        titleLabel.text = profile.title

        profileImage.setImageWithURL(
            NSURL(string: profile.image_url),
            placeholderImage: UIImage(named: "DefaultPerson"))

        backgroundImage.setImageWithURL(
            NSURL(string: profile.image_url),
            placeholderImage: UIImage(named: "DefaultPerson"))
    }
}
