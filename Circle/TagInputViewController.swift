//
//  TagInputViewController.swift
//  Circle
//
//  Created by Michael Hahn on 3/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TagInputViewController: UIViewController,
    UITextFieldDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDelegate,
    TokenFieldDataSource,
    TokenFieldDelegate
{
    
    enum Themes {
        case Onboarding
        case Regular
    }

    @IBOutlet private(set) weak var tokenField: TokenField!
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet weak var viewDescriptionLabel: UILabel!
    
    var addNextButton: Bool = false

    private var theme: Themes = .Regular
    private var deletedTags = Array<Services.Profile.Containers.TagV1>()
    private var newTag: Services.Profile.Containers.TagV1?
    private var selectedTags = Array<Services.Profile.Containers.TagV1>()
    private var suggestedTags = Array<Services.Profile.Containers.TagV1>()
    private var activityIndicator: CircleActivityIndicatorView?
    
    private var tokenFieldBottomBorder: UIView?
    private var suggestionCollectionViewCellBackgroundColor = UIColor.whiteColor()
    private var suggestionCollectionViewCellTextColor = UIColor.appDefaultDarkTextColor()
    
    static func getNibName() -> String {
        return "TagInputViewController"
    }
    
    convenience init(existingTags: Array<Services.Profile.Containers.TagV1>? = nil, theme withTheme: Themes = .Regular) {
        self.init(nibName: "TagInputViewController", bundle: nil)
        if existingTags != nil {
            selectedTags.extend(existingTags!)
        }
        theme = withTheme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        configureCollectionView()
        configureTokenField()
        configureViewByTheme()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func configureNavigationBar() {
        title = AppStrings.ProfileSectionExpertiseTitle
        if addNextButton {
            addNextButtonWithAction("done:")
        }
        else {
            addDoneButtonWithAction("done:")
        }
        
        addCloseButtonWithAction("cancel:")
    }
    
    private func configureTokenField() {
        tokenField.dataSource = self
        tokenField.delegate = self
        tokenFieldBottomBorder = tokenField.addBottomBorder(offset: 0.0)
        tokenField.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.registerNib(
            TagSuggestionCollectionViewCell.nib,
            forCellWithReuseIdentifier: TagSuggestionCollectionViewCell.classReuseIdentifier
        )
    }
    
    private func configureViewByTheme() {
        switch theme {
        case .Onboarding:
            view.backgroundColor = UIColor.appUIBackgroundColor()
            collectionView.backgroundColor = UIColor.appUIBackgroundColor()
            tokenField.backgroundColor = UIColor.appUIBackgroundColor()
            tokenField.tokenBackgroundViewBackgroundColor = UIColor.appUIBackgroundColor()
            tokenField.tokenTitleLabelTextColor = UIColor.whiteColor()
            tokenField.tokenBorderColor = UIColor.whiteColor()
            tokenField.tokenHighlightedBackgroundViewBackgroundColor = UIColor.whiteColor()
            tokenField.tokenHighlightedTokenTitleLabelTextColor = UIColor.appUIBackgroundColor()
            tokenField.tokenHighlightedBorderColor = UIColor.appUIBackgroundColor()
            viewDescriptionLabel.textColor = UIColor.whiteColor()
            suggestionCollectionViewCellBackgroundColor = UIColor.appUIBackgroundColor()
            suggestionCollectionViewCellTextColor = UIColor.whiteColor()
            tokenFieldBottomBorder?.backgroundColor = UIColor.whiteColor()
            tokenField.tokenTintColor = UIColor.whiteColor()
            tokenField.keyboardAppearance = .Dark
            // TODO this shouldn't need to be here
            tokenField.reloadData()
        case .Regular:
            view.backgroundColor = UIColor.appViewBackgroundColor()
            collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        }
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newTag != nil ? suggestedTags.count + 1 : suggestedTags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TagSuggestionCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as! TagSuggestionCollectionViewCell
        
        var suggestedTag: Services.Profile.Containers.TagV1?
        if shouldUseNewTag(indexPath) {
            suggestedTag = newTag
        } else {
            suggestedTag = suggestedTags[indexPath.row]
        }
        cell.suggestedTag = suggestedTag
        cell.backgroundColor = suggestionCollectionViewCellBackgroundColor
        cell.tagSuggestionLabel.textColor = suggestionCollectionViewCellTextColor
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let tag: Services.Profile.Containers.TagV1
        if shouldUseNewTag(indexPath) {
            tag = newTag!
        } else {
            tag = suggestedTags[indexPath.row]
        }
        selectedTags.append(tag)
        newTag = nil
        tokenField.reloadData()
        suggestedTags.removeAll(keepCapacity: false)
        if !tokenField.isFirstResponder() {
            tokenField.becomeFirstResponder()
        }
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, 44.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }

    // MARK: - TokenFieldDelegate
    
    func tokenField(tokenField: TokenField, didChangeText text: String) {
        if text == "" {
            newTag = nil
            suggestedTags.removeAll(keepCapacity: false)
            collectionView.reloadData()
        } else {
            Services.Search.Actions.search(text, category: .Skills, attribute: nil, attributeValue: nil, objects: nil) { (result, error) -> Void in
                if (result?.skills != nil) {
                    self.suggestedTags = result!.skills!
                }
                
                var tagBuilder: Services.Profile.Containers.TagV1Builder
                if self.newTag != nil {
                    tagBuilder = self.newTag!.toBuilder()
                } else {
                    tagBuilder = Services.Profile.Containers.TagV1.builder()
                    tagBuilder.tagType = .Skill
                }
                tagBuilder.name = text
                self.newTag = tagBuilder.build()
                self.collectionView.reloadData()
            }
        }
    }
    
    func tokenField(tokenField: TokenField, didEnterText text: String) {
        selectedTags.append(newTag!)
        newTag = nil
        suggestedTags.removeAll(keepCapacity: false)
        tokenField.reloadData()
        collectionView.reloadData()
    }
    
    func tokenField(tokenField: TokenField, didDeleteTokenAtIndex index: UInt) {
        let deletedTag = selectedTags.removeAtIndex(Int(index)) as Services.Profile.Containers.TagV1
        if deletedTag.hasId {
            deletedTags.append(deletedTag)
        }
        tokenField.reloadData()
    }
    
    func tokenFieldDidCancelEditing(tokenField: TokenField) {
        newTag = nil
        suggestedTags.removeAll(keepCapacity: false)
        collectionView.reloadData()
    }
    
    // MARK - TokenFieldDataSource
    
    func tokenField(tokenField: TokenField, titleForTokenAtIndex index: UInt) -> String {
        return selectedTags[Int(index)].name
    }

    func numberOfTokensInTokenField(tokenField: TokenField) -> UInt {
        return UInt(selectedTags.count)
    }
    
    // MARK: - IBActions
    
    @IBAction func done(sender: AnyObject!) {
        // TODO only display done button if we have added a tag
        activityIndicator = view.addActivityIndicator()
        
        var storedError: NSError!
        var actionsGroup = dispatch_group_create()
        let profileId = AuthViewController.getLoggedInUserProfile()!.id
        if selectedTags.count > 0 {
            dispatch_group_enter(actionsGroup)
            Services.Profile.Actions.addTags(profileId, tags: selectedTags) { (error) in
                // TODO return any tags that were created so we can add them to the ObjectStore
                if let error = error {
                    storedError = error
                }
                dispatch_group_leave(actionsGroup)
            }
        }
        if deletedTags.count > 0 {
            dispatch_group_enter(actionsGroup)
            Services.Profile.Actions.removeTags(profileId, tags: deletedTags) { (error) -> Void in
                if let error = error {
                    storedError = error
                }
                dispatch_group_leave(actionsGroup)
            }
        }
        dispatch_group_notify(actionsGroup, GlobalMainQueue) { () -> Void in
            // TODO print the storedError if there is an error
            self.dismissView()
        }
    }
    
    @IBAction func cancel(sender: AnyObject!) {
        dismissView()
    }
    
    // MARK: - Helpers
    
    private func shouldUseNewTag(indexPath: NSIndexPath) -> Bool {
        return (indexPath.row + 1) > suggestedTags.count
    }
    
    private func dismissView() {
        tokenField.resignFirstResponder()
        if activityIndicator != nil {
            activityIndicator!.stopAnimating()
        }
        if addNextButton {
            saveAndNextButtonTapped()
        }
        else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func saveAndNextButtonTapped() {
        let notificationsVC = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
}
