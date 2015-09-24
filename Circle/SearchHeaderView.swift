//
//  SearchHeaderView.swift
//  Circle
//
//  Created by Ravi Rani on 12/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

protocol SearchHeaderViewDelegate {
    func didCancel(sender: UIView)
}

class SearchHeaderView: UIView {
    
    @IBOutlet weak private(set) var cancelButton: UIButton!
    @IBOutlet weak private(set) var searchTextField: CircleTextField!
    @IBOutlet weak private(set) var searchTextFieldHeightConstraint: NSLayoutConstraint!    
    @IBOutlet weak private(set) var searchTextFieldTrailingSpaceConstraint: NSLayoutConstraint!
    
    var containerBackgroundColor = UIColor.appViewBackgroundColor()
    var delegate: SearchHeaderViewDelegate?
    var searchFieldBackgroundColor = UIColor.appSearchTextFieldBackground()
    var searchFieldTextColor = UIColor.appDefaultDarkTextColor()
    var searchFieldTintColor = UIColor.appTintColor()

    private var leftViewImageView: UIImageView!
    
    class var height: CGFloat {
        return 50.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        customizeSearchField()
        hideCancelButton()
    }
    
    
    // MARK: - Configuration
    
    private func customizeSearchField() {
        let leftView = UIView(frame: CGRectMake(
            10.0,
            0.0,
            36.0,
            searchTextField.frame.height
        ))
        leftView.backgroundColor = UIColor.clearColor()
        leftViewImageView = UIImageView(image: UIImage(named: "searchbar_search")?.imageWithRenderingMode(.AlwaysTemplate))
        leftViewImageView.contentMode = .Center
        leftViewImageView.frame = CGRectMake(10.0, (searchTextField.frame.height - 16.0)/2.0, 16.0, 16.0)
        leftView.addSubview(leftViewImageView)
        
        searchTextField.leftViewMode = .Always
        searchTextField.leftView = leftView
        searchTextField.clearButtonMode = .WhileEditing
        
        searchFieldBackgroundColor = UIColor.whiteColor()
        containerBackgroundColor = UIColor.whiteColor()
        searchFieldTintColor = UIColor.appTintColor()
        updateView()
    }
    
    func updateView() {
        leftViewImageView.tintColor = searchFieldTextColor
        searchTextField.backgroundColor = searchFieldBackgroundColor
        searchTextField.textColor = searchFieldTextColor
        searchTextField.tintColor = searchFieldTintColor
        searchTextField.superview?.backgroundColor = containerBackgroundColor
    }

    // MARK: - CancelButtonState
    
    func showCancelButton() {
        searchTextFieldTrailingSpaceConstraint.constant = frame.width - cancelButton.frame.origin.x + 10.0
        searchTextField.setNeedsUpdateConstraints()
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.searchTextField.layoutIfNeeded()
                self.cancelButton.alpha = 1.0
            },
            completion: nil
        )
    }
    
    func hideCancelButton() {
        searchTextFieldTrailingSpaceConstraint.constant = 0.0
        searchTextField.setNeedsUpdateConstraints()
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.searchTextField.layoutIfNeeded()
                self.cancelButton.alpha = 0.0
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
        self.delegate?.didCancel(self)
    }
}
