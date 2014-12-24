//
//  SearchViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/23/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var overlayButton: UIButton!
    
    private var searchHeaderView: SearchHeaderCollectionReusableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeCollectionView()
        customizeOverlayButton()
    }

    // MARK: - Configuration

    private func customizeCollectionView() {
        collectionView!.backgroundColor = UIColor.viewBackgroundColor()
        collectionView!.registerNib(
            UINib(nibName: "SearchViewCardCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: SearchViewCardCollectionViewCell.classReuseIdentifier
        )
        
        collectionView!.registerNib(
            UINib(nibName: "SearchHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: SearchHeaderCollectionReusableView.classReuseIdentifier
        )
    }
    
    private func customizeOverlayButton() {
        overlayButton.backgroundColor = UIColor.searchOverlayButtonBackgroundColor()
        overlayButton.opaque = true
    }
    
    // MARK: - Collection View Data Source
    
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
        cell.frameY = finalFrame.origin.y + (view.frameHeight - finalFrame.origin.y)
        let delay = 0.2 * (Double(indexPath.row) + 1.0)

        UIView.animateWithDuration(
            0.9,
            delay: delay,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.6,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                cell.frame = finalFrame
            },
            completion: nil
        )

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: SearchHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
        ) as SearchHeaderCollectionReusableView
        
        searchHeaderView = supplementaryView
        return supplementaryView
    }

    // MARK: Collection View Delegate
    
    
    // MARK: - Flow Layout Delegate

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake((section == 0 ? 5.0 : 15.0), 0.0, 0.0, 0.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frameWidth, 90.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(view.frameWidth, SearchHeaderCollectionReusableView.height)
        }

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
        searchHeaderView.searchTextField.resignFirstResponder()
    }

    // MARK: - Helpers
    
    private func onSearchTextFieldBeginFocus() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.overlayButton.alpha = 1.0
        })
    }
    
    private func onSearchTextFieldRemoveFocus() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.overlayButton.alpha = 0.0
        })
    }
}
