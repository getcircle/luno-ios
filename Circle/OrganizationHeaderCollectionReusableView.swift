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
    
    @IBOutlet weak var profileImage: CircleImageView!

    override class var classReuseIdentifier: String {
        return "OrganizationHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 200.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.addRoundCorners(radius: 3.0)
    }
    
    func setOrganization(organization: Services.Organization.Containers.OrganizationV1) {
        profileImage.setImageWithURL(NSURL(string: organization.imageUrl)!, animated: true)
    }
}
