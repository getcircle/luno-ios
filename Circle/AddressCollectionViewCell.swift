//
//  AddressCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 3/2/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MapKit
import ProtobufRegistry

class AddressCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var addressLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var genericNextImage: UIImageView!
    
    override class var classReuseIdentifier: String {
        return "AddressCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 70.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        genericNextImage.image = UIImage(named: "Next")?.imageWithRenderingMode(.AlwaysTemplate)
        genericNextImage.tintColor = UIColor.appKeyValueNextImageTintColor()
    }

    // MARK: - Data
    
    override func setData(data: AnyObject) {
        if let office = data as? Services.Organization.Containers.LocationV1 {
            addressLabel.text = office.shortLocationsAddress()
            cityStateLabel.text = office.cityRegionPostalCode()
        }
    }
}
