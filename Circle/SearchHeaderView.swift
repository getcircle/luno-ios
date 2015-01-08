//
//  SearchHeaderView.swift
//  Circle
//
//  Created by Ravi Rani on 12/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class SearchHeaderView: UIView {

    @IBOutlet weak private(set) var cancelButton: UIButton!
    @IBOutlet weak private(set) var searchTextField: UITextField!
    @IBOutlet weak private(set) var searchTextFieldTrailingSpaceConstraint: NSLayoutConstraint!
    
    class var height: CGFloat {
        return 54.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        customizeSearchField()
    }
    
    
    // MARK: - Configuration
    
    private func customizeSearchField() {
        var leftView = UIView(frame: CGRectMake(
            10.0,
            0.0,
            36.0,
            searchTextField.frameHeight
            ))
        leftView.backgroundColor = UIColor.clearColor()
        var leftViewImage = UIImageView(image: UIImage(named: "Search"))
        leftViewImage.contentMode = .ScaleAspectFit
        leftViewImage.frame = CGRectMake(10.0, 9.0, 16.0, 16.0)
        leftView.addSubview(leftViewImage)
        
        searchTextField.leftViewMode = .Always
        searchTextField.leftView = leftView
        
        searchTextField.backgroundColor = UIColor.searchTextFieldBackground()
        searchTextField.addRoundCorners()
        searchTextField.superview?.backgroundColor = UIColor.viewBackgroundColor()
    }

    // MARK: - CancelButtonState
    
    func showCancelButton() {
        searchTextFieldTrailingSpaceConstraint.constant = frameWidth - cancelButton.frameX + 10.0
        searchTextField.setNeedsUpdateConstraints()
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.searchTextField.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func hideCancelButton() {
        searchTextFieldTrailingSpaceConstraint.constant = 10.0
        searchTextField.setNeedsUpdateConstraints()
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.searchTextField.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func removeFocusFromSearchField() {
        searchTextField.resignFirstResponder()
    }

    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(sender: AnyObject!) {
        hideCancelButton()
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
    }
}
