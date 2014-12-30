//
//  LocationCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: CircleCollectionViewCell {

    override class var classReuseIdentifier: String {
        return "LocationCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 48.0
    }
    
    @IBOutlet weak private(set) var addressLabel: UILabel!
    @IBOutlet weak private(set) var locationNameLabel: UILabel!
    @IBOutlet weak private(set) var numbrOfPeopleLabel: UILabel!
    
    override func setData(data: AnyObject) {
        if let locationDictionary = data as? [String: String] {
            locationNameLabel.text = locationDictionary["name"]
            addressLabel.text = locationDictionary["address"]
            numbrOfPeopleLabel.text = locationDictionary["count"]
        }
    }
}
