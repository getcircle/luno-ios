//
//  AppreciateActionCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 3/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class AppreciateActionCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var appreciateButton: UIButton!
    
    override class var classReuseIdentifier: String {
        return "AppreciateActionCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 70.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureActionButton()
    }
    
    // MARK: - Configuration
    
    private func configureActionButton() {
        appreciateButton.addRoundCorners(radius: 2.0)
        appreciateButton.backgroundColor = UIColor.appCTABackgroundColor()
        appreciateButton.setTitleColor(UIColor.appCTATextColor(), forState: .Normal)
        appreciateButton.tintColor = UIColor.whiteColor()
        appreciateButton.titleLabel?.font = UIFont.appCTATitleFont()
        appreciateButton.convertToTemplateImageForState(.Normal)
        appreciateButton.setCustomAttributedTitle(
            AppStrings.AppreciateCTATitle.localizedUppercaseString(),
            forState: .Normal
        )
    }
    
    // MARK: - Data
    
    override func setData(data: AnyObject) {
    }
}
