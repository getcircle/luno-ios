//
//  OrganizationHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/22/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OrganizationHeaderCollectionReusableView: CircleCollectionReusableView {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameNavLabel: UILabel!
    @IBOutlet weak var profileImage: CircleImageView!
    
    private(set) var visualEffectView: UIVisualEffectView!
    
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
        backgroundImage.backgroundColor = UIColor.whiteColor()
        profileImage.backgroundColor = UIColor.whiteColor()
    }
    
    func setOrganization(organization: OrganizationService.Containers.Organization) {
        nameLabel.text = organization.name
        nameNavLabel.text = nameLabel.text
        profileImage.image = UIImage(named: organization.name)
        backgroundImage.image = UIImage(named: organization.name)
    }
}
