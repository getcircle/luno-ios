//
//  UIImageViewExtension.swift
//  Circle
//
//  Created by Ravi Rani on 11/27/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

extension UIImageView {

    // It is assumed that the image would be 1:1 aspect ratio
    func makeItCircular(addBorder: Bool) {
        layer.cornerRadiusWithMaskToBounds(bounds.size.width/2.0)
        
        if addBorder {
            layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3).CGColor
            layer.borderWidth = 1.0
        }
    }

    func setImageWithPerson(person: Person!) {
        setImageWithURL(
            NSURL(string: person.profileImageURL),
            placeholderImage: UIImage(named: "DefaultPerson")
        )
    }
    
    func setImageWithProfileImageURL(profileImageURL: String) {
        setImageWithURL(
            NSURL(string: profileImageURL),
            placeholderImage: UIImage(named: "DefaultPerson")
        )
    }
}

