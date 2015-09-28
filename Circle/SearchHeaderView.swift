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
    
    let searchFieldLeftViewDefaultWidth = CGFloat(44.0)
    
    @IBOutlet weak private(set) var cancelButton: UIButton!
    @IBOutlet weak private(set) var searchTextField: CircleTextField!
    @IBOutlet weak private(set) var searchTextFieldHeightConstraint: NSLayoutConstraint!    
    @IBOutlet weak private(set) var searchTextFieldTrailingSpaceConstraint: NSLayoutConstraint!
    
    var containerBackgroundColor = UIColor.appViewBackgroundColor()
    var delegate: SearchHeaderViewDelegate?
    var searchFieldBackgroundColor = UIColor.appSearchTextFieldBackground()
    var searchFieldTextColor = UIColor.appPrimaryTextColor()
    var searchFieldTintColor = UIColor.appHighlightColor()
    var searchFieldLeftView = UIView()
    
    weak var searchFieldTagView: UIView?

    private var leftViewImageView: UIImageView!
    
    class var height: CGFloat {
        return 44.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        customizeSearchField()
        hideCancelButton()
    }
    
    
    // MARK: - Configuration
    
    private func customizeSearchField() {
        searchFieldLeftView.frame = CGRectMake(0.0, 0.0, searchFieldLeftViewDefaultWidth, searchTextField.frame.height)
        searchFieldLeftView.backgroundColor = UIColor.clearColor()
        leftViewImageView = UIImageView(image: UIImage(named: "searchbar_search")?.imageWithRenderingMode(.AlwaysTemplate))
        leftViewImageView.contentMode = .Center
        leftViewImageView.frame = CGRectMake(14.0, (searchTextField.frame.height - 16.0)/2.0, 16.0, 16.0)
        leftViewImageView.tintColor = UIColor.appSearchIconTintColor()
        searchFieldLeftView.addSubview(leftViewImageView)
        
        searchTextField.leftViewMode = .Always
        searchTextField.leftView = searchFieldLeftView
        searchTextField.clearButtonMode = .WhileEditing
        
        searchFieldBackgroundColor = UIColor.whiteColor()
        containerBackgroundColor = UIColor.whiteColor()
        updateView()
    }
    
    func updateView() {
        searchTextField.backgroundColor = searchFieldBackgroundColor
        searchTextField.textColor = searchFieldTextColor
        searchTextField.tintColor = searchFieldTintColor
        searchTextField.superview?.backgroundColor = containerBackgroundColor
        cancelButton.setTitleColor(UIColor.appHighlightColor(), forState: .Normal)
    }
    
    // MARK: - Tag View
    
    func showTagWithTitle(title: String) {
        searchFieldTagView?.removeFromSuperview()
        
        let tag = UIButton()
        tag.backgroundColor = UIColor.appHighlightColor()
        tag.contentEdgeInsets = UIEdgeInsetsMake(9.0, 14.0, 9.0, 14.0)
        tag.setAttributedTitle(NSAttributedString(string: title, attributes: [NSFontAttributeName: UIFont.boldFont(11.0), NSKernAttributeName: 1.0, NSForegroundColorAttributeName: UIColor.whiteColor()]), forState: .Normal)
        tag.sizeToFit()
        tag.layer.cornerRadius = 3.0
        
        let tagPadding = CGFloat(8.0)
        
        searchFieldLeftView.frameWidth = searchFieldLeftViewDefaultWidth + tag.frameWidth
        tag.frame = CGRectMake(leftViewImageView.frameRight + tagPadding, floor((searchFieldLeftView.frameHeight - tag.frameHeight) / 2), tag.frameWidth, tag.frameHeight)
        searchFieldLeftView.addSubview(tag)
        
        searchFieldTagView = tag
        
        searchTextField.placeholder = nil
    }
    
    func hideTag() {
        searchFieldTagView?.removeFromSuperview()
        
        searchFieldLeftView.frameWidth = searchFieldLeftViewDefaultWidth
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
