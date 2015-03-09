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
    @IBOutlet weak private(set) var pushesNewViewImage: UIImageView!
    
    private(set) var initialFontSize: CGFloat!
    private(set) var defaultSelectionBackgroundView: UIView!
    
    override class var classReuseIdentifier: String {
        return "SettingsCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 44.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        initialFontSize = itemLabel.font.pointSize
        defaultSelectionBackgroundView = selectedBackgroundView
        pushesNewViewImage.image = pushesNewViewImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        pushesNewViewImage.tintColor = UIColor.appKeyValueNextImageTintColor()
    }
    
    override func setData(data: AnyObject) {
        if let settingsCellDataDictionary = data as? [String: AnyObject] {
            if let labelText = settingsCellDataDictionary["text"] as? String {
                itemLabel.text = labelText
            }
        }
    }
}
