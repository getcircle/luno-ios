//
//  SettingsCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 2/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class SettingsCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var itemLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "SettingsCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 44.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setData(data: AnyObject) {
        if let settingsCellDataDictionary = data as? [String: AnyObject] {
            if let labelText = settingsCellDataDictionary["text"] as? String {
                itemLabel.text = labelText
            }
        }
    }
}
