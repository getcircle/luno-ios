//
//  ProfilesSelectorViewController.swift
//  Circle
//
//  Created by Ravi Rani on 5/25/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

protocol ProfileSelectorDelegate {
    // Bool is to indicate whether the view should be dismissed immediately
    // If not, it is the responsibility of the delegate to present blocking view, error cases, & dismiss on success.
    func onSelectedProfiles(profiles: Array<Services.Profile.Containers.ProfileV1>) -> Bool
}

class ProfilesSelectorViewController: ProfilesViewController,
    TokenFieldDataSource,
    TokenFieldDelegate
{
    var selectedProfiles = Array<Services.Profile.Containers.ProfileV1>()
    private var selectedProfileIDs = Set<String>()
    private var tokenField: TokenField?
    private var tokenFieldBottomBorder: UIView?
    private var allowsMultipleSelection = false
    private var searchPlaceholderText: String?
    private var searchPlaceholderComment: String?
    
    var profileSelectorDelegate: ProfileSelectorDelegate?
    
    // MARK: Initialization
    
    convenience init(allowsMultipleSelection multipleSelection: Bool, searchPlaceholderText text: String? = nil, searchPlaceholderComment comment: String? = nil) {
        self.init(isFilterView: false)

        allowsMultipleSelection = multipleSelection
        searchPlaceholderText = text
        searchPlaceholderComment = comment
    }
    
    override func initializeDataSource() -> CardDataSource {
        let dataSource = super.initializeDataSource()
        do {
            try (dataSource as! ProfilesDataSource).configureForOrganization()
        }
        catch {
            print("Error: \(error)")
        }
        (dataSource as! ProfilesDataSource).searchLocation = .Modal
        return dataSource
    }
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocalState()
        if allowsMultipleSelection {
            configureNavigationBar()
            configureTokenField()
        }
    }

    // MARK: Configuration
    
    override func filterPlaceHolderText() -> String {
        return searchPlaceholderText ?? super.filterPlaceHolderText()
    }
    
    override func filterPlaceHolderComment() -> String {
        return searchPlaceholderComment ?? super.filterPlaceHolderComment()
    }
    
    private func configureLocalState() {
        if selectedProfiles.count > 0 {
            for profile in selectedProfiles {
                selectedProfileIDs.insert(profile.id)
            }
        }
    }
    
    private func configureNavigationBar() {
        addDoneButtonWithAction("doneButtonTapped:")
        addCloseButtonWithAction("cancelButtonTapped:")
    }

    private func configureTokenField() {
        let aTokenField = TokenField(forAutoLayout: ())
        aTokenField.tokenHeight = 34.0
        aTokenField.tokenTopPadding = 6.0
        aTokenField.tokenBottomPadding = 4.0
        aTokenField.tokenCornerRadius = 5.0
        
        view.addSubview(aTokenField)
        aTokenField.backgroundColor = UIColor.whiteColor()
        aTokenField.tokenBackgroundViewBackgroundColor = aTokenField.tokenHighlightedBackgroundViewBackgroundColor.colorWithAlphaComponent(0.1)
        aTokenField.tokenBorderColor = UIColor.whiteColor()
        aTokenField.tokenHighlightedBorderColor = UIColor.whiteColor()
        
        aTokenField.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        aTokenField.autoSetDimension(.Height, toSize: 44.0)
        aTokenField.dataSource = self
        aTokenField.delegate = self
        aTokenField.reloadData()
        aTokenField.becomeFirstResponder()
        
        collectionViewVerticalSpaceConstraint!.constant = 44.0
        collectionView.setNeedsUpdateConstraints()

        tokenFieldBottomBorder = aTokenField.addBottomBorder()
        tokenField = aTokenField
    }
    
    // MARK: IBActions
    
    @IBAction func doneButtonTapped(sender: AnyObject!) {
        if let delegate = profileSelectorDelegate where selectedProfiles.count > 0 {
            if delegate.onSelectedProfiles(selectedProfiles) {
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    @IBAction func cancelButtonTapped(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 where !selectedProfileIDs.contains(profile.id) {
            selectedProfiles.append(profile)
            selectedProfileIDs.insert(profile.id)
            tokenField?.reloadData()
            if allowsMultipleSelection {
                tokenField?.becomeFirstResponder()
            }
            else {
                doneButtonTapped(nil)
            }
            
            // Update results
            filter("")
        }
    }
    
    // MARK: TokenFieldDataSource

    func tokenField(tokenField: TokenField, titleForTokenAtIndex index: UInt) -> String {
        return selectedProfiles[Int(index)].fullName
    }
    
    func numberOfTokensInTokenField(tokenField: TokenField) -> UInt {
        return UInt(selectedProfiles.count)
    }
    
    // MARK: TokenFieldDelegate

    func tokenField(tokenField: TokenField, didChangeText text: String) {
        filter(text)
    }

    func tokenField(tokenField: TokenField, didDeleteTokenAtIndex index: UInt) {
        let deletedProfile = selectedProfiles.removeAtIndex(Int(index)) as Services.Profile.Containers.ProfileV1
        selectedProfileIDs.remove(deletedProfile.id)
        tokenField.reloadData()
    }
}
