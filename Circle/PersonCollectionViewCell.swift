//
//  PersonCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: CircleCollectionViewCell {

    override class var classReuseIdentifier: String {
        return "PersonCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 48.0
    }

    @IBOutlet weak private(set) var nameLabel: UILabel!
    @IBOutlet weak private(set) var profileImageView: UIImageView!
    @IBOutlet weak private(set) var subTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.makeItCircular(false)
    }
    
    override func setData(data: AnyObject) {
        if let person = data as? Person {
            nameLabel.text = person.firstName + " " + person.lastName
            subTextLabel.text = ["January 18th", "February 1st", "February 8th"][Int(arc4random()%3)]
            profileImageView.setImageWithPerson(person)
        }
    }
}
