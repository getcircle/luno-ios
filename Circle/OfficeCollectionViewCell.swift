//
//  OfficeCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OfficeCollectionViewCell: CircleCollectionViewCell {

    override class var classReuseIdentifier: String {
        return "OfficeCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 48.0
    }
    
    @IBOutlet weak private(set) var officeNameLabel: UILabel!
    @IBOutlet weak private(set) var numbrOfPeopleLabel: UILabel!
    
    override func setData(data: AnyObject) {
        if let location = data as? Services.Organization.Containers.LocationV1 {
            officeNameLabel.text = location.address.officeName()
            numbrOfPeopleLabel.text = String(location.profile_count)
        }
    }
}
