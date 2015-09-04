//
//  DetailHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 8/6/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

protocol EditImageButtonDelegate {
    func onEditImageButtonTapped(sender: UIView!)
}

class DetailHeaderCollectionReusableView: CircleCollectionReusableView {

    internal var editImageButton: UIButton?
    var editImageButtonDelegate: EditImageButtonDelegate?
    
    func addEditImageButton(parentView: UIView) {
        editImageButton = UIButton(forAutoLayout: ())
        
        if let editImageButton = editImageButton {
            editImageButton.setImage(UIImage(named: "edit_profile_camera"), forState: .Normal)
            editImageButton.convertToTemplateImageForState(.Normal)
            editImageButton.tintColor = UIColor.appViewBackgroundColor()
            editImageButton.hidden = true
            editImageButton.contentHorizontalAlignment = .Right
            editImageButton.contentVerticalAlignment = .Center
            editImageButton.imageView?.contentMode = .ScaleAspectFill
            parentView.addSubview(editImageButton)
            editImageButton.addTarget(self, action: "editImageButtonTapped:", forControlEvents: .TouchUpInside)
            editImageButton.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
            editImageButton.autoSetDimension(.Height, toSize: 40.0)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func editImageButtonTapped(sender: AnyObject!) {
        editImageButtonDelegate?.onEditImageButtonTapped(sender as! UIView)
    }
    
    func setEditImageButtonHidden(hidden: Bool) {
        if editImageButton == nil {
            addEditImageButton(self)
        }
        editImageButton?.hidden = hidden
    }
}