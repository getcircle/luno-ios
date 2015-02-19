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
    
    @IBOutlet weak private(set) var addressLabel: UILabel!
    @IBOutlet weak private(set) var officeNameLabel: UILabel!
    @IBOutlet weak private(set) var numbrOfPeopleLabel: UILabel!
    
    override func setData(data: AnyObject) {
        if let address = data as? OrganizationService.Containers.Address {
            officeNameLabel.text = "\(address.city), \(address.region)"
            // HACK: address_2 isn't filled in right now
//            addressLabel.text = "\(address.address_1), \(address.address_2)"
            addressLabel.text = "\(address.address_1)"
            numbrOfPeopleLabel.text = address.profile_count
        }
    }
}
