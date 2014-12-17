//
//  ProfileHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameNavLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!

    private var visualEffectView: UIVisualEffectView!
    
    class var classReuseIdentifier: String {
        return "ProfileHeaderView"
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
    
    func setPerson(person: Person!) {
        nameLabel.text = person.firstName + " " + person.lastName
        nameNavLabel.text = nameLabel.text
        titleLabel.text = person.title

        profileImage.setImageWithURL(
            NSURL(string: person.profileImageURL),
            placeholderImage: UIImage(named: "DefaultPerson"))

        backgroundImage.setImageWithURL(
            NSURL(string: person.profileImageURL),
            placeholderImage: UIImage(named: "DefaultPerson"))
    }
}
