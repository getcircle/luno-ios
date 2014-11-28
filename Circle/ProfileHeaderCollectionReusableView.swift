//
//  ProfileHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    var visualEffectView: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        let blurEffect = UIBlurEffect(style: .Dark)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = backgroundImage.frame
        insertSubview(visualEffectView, aboveSubview: backgroundImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.makeItCircular(true)
        visualEffectView.frame = backgroundImage.frame
    }
    
    func setPerson(person: Person!) {
        nameLabel.text = person.firstName + " " + person.lastName
        titleLabel.text = person.title

        profileImage.setImageWithURL(
            NSURL(string: person.profileImageURL),
            placeholderImage: UIImage(named: "DefaultPerson"))

        backgroundImage.setImageWithURL(
            NSURL(string: person.profileImageURL),
            placeholderImage: UIImage(named: "DefaultPerson"))
    }
}
