//
//  AddNoteCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 1/26/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class AddNoteCollectionViewCell: CircleCollectionViewCell {
    
    @IBOutlet weak private(set) var addNoteButton: UIButton!
    @IBOutlet weak private(set) var addNoteLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "AddNoteCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 70.0
    }
    
    override class var lineSpacing: CGFloat {
        return 0.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureAddNoteButton()
        selectedBackgroundView = nil
    }
    
    // MARK: - Configuration
    
    private func configureAddNoteButton() {
        addNoteButton.addRoundCorners(radius: 2.0)
        addNoteButton.backgroundColor = UIColor.appCTABackgroundColor()
        addNoteButton.setTitleColor(UIColor.appCTATextColor(), forState: .Normal)
        addNoteButton.tintColor = UIColor.whiteColor()
        addNoteButton.titleLabel?.font = UIFont.appCTATitleFont()
        addNoteButton.convertToTemplateImageForState(.Normal)
        addNoteButton.setCustomAttributedTitle(
            AppStrings.AddNoteCTATitle.uppercaseStringWithLocale(NSLocale.currentLocale()),
            forState: .Normal
        )
        
        addNoteButton.userInteractionEnabled = false
    }
    
    override func setData(data: AnyObject) {}

}
