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
        return "AddNoteCell"
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
        addNoteButton.tintColor = UIColor.appActionButtonTintColor()
        addNoteButton.setTitleColor(UIColor.appActionButtonTintColor(), forState: .Normal)
        addNoteButton.setImage(
            addNoteButton.imageForState(.Normal)!.imageWithRenderingMode(.AlwaysTemplate),
            forState: .Normal
        )
        addNoteButton.userInteractionEnabled = false
    }
    
    override func setData(data: AnyObject) {}

}
