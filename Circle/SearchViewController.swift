//
//  SearchViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/23/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak private(set) var cancelButton: UIButton!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var overlayButton: UIButton!
    @IBOutlet weak private(set) var searchTextFieldTrailingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var searchTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeCollectionView()
        customizeSearchTextField()
        customizeOverlayButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Configuration

    private func customizeSearchTextField() {
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

    private func customizeCollectionView() {
        collectionView!.backgroundColor = UIColor.viewBackgroundColor()
        collectionView!.registerNib(
            UINib(nibName: "SearchViewCardCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: SearchViewCardCollectionViewCell.classReuseIdentifier)
    }
    
    private func customizeOverlayButton() {
        overlayButton.backgroundColor = UIColor.searchOverlayButtonBackgroundColor()
        overlayButton.opaque = true
    }
    
    
    // MARK: - Collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            SearchViewCardCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath) as SearchViewCardCollectionViewCell

        let finalFrame = cell.frame
        cell.frameY = finalFrame.origin.y + 400.0
        let delay = 0.2 * (Double(indexPath.row) + 1.0)

        UIView.animateWithDuration(
            0.9,
            delay: delay,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.6,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                cell.frame = finalFrame
            }, completion: nil
        )

        return cell
    }

    // MARK: Collection View delegate
    
    
    // MARK: - Layout delegate

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15.0, 0.0, 0.0, 0.0)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
        return CGSizeMake(collectionView.frameWidth, 90.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        onSearchTextFieldBeginFocus()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        overlayButtonTapped(textField)
        onSearchTextFieldRemoveFocus()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        overlayButtonTapped(textField)
        onSearchTextFieldRemoveFocus()
        return true
    }
    
    
    // MARK: - IBActions
    
    @IBAction func overlayButtonTapped(sender: AnyObject!) {
        searchTextField.resignFirstResponder()
    }

    @IBAction func cancelButtonTapped(sender: AnyObject!) {
        searchTextField.resignFirstResponder()
    }
    

    // MARK: - Helpers
    
    private func onSearchTextFieldBeginFocus() {
        searchTextFieldTrailingSpaceConstraint.constant = view.frameWidth - cancelButton.frameX + 10.0
        searchTextField.setNeedsUpdateConstraints()
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.overlayButton.alpha = 1.0
                self.searchTextField.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    private func onSearchTextFieldRemoveFocus() {
        searchTextFieldTrailingSpaceConstraint.constant = 10.0
        searchTextField.setNeedsUpdateConstraints()
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.overlayButton.alpha = 0.0
                self.searchTextField.layoutIfNeeded()
            },
            completion: nil
        )
    }
}
