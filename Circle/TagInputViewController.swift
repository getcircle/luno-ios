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

    @IBOutlet private(set) weak var tokenField: TokenField!
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    // TODO this should be 2 * the tokenHeight
    private var tokenFieldMaxHeight: CGFloat = 2 * 40.0
    private var newTag: ProfileService.Containers.Tag?
    private var selectedTags = Array<ProfileService.Containers.Tag>()
    private var suggestedTags = Array<ProfileService.Containers.Tag>()
    
    class func getNibName() -> String {
        return "TagInputViewController"
    }
    
    convenience init(existingTags: Array<ProfileService.Containers.Tag>) {
        self.init(nibName: "TagInputViewController", bundle: nil)
        selectedTags.extend(existingTags)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        configureCollectionView()
        configureTokenField()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.appViewBackgroundColor()
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func configureNavigationBar() {
        title = AppStrings.ProfileSectionExpertiseTitle
        addDoneButtonWithAction("done:")
        addCloseButtonWithAction("cancel:")
    }
    
    private func configureTokenField() {
        tokenField.maxHeight = tokenFieldMaxHeight
        tokenField.dataSource = self
        tokenField.delegate = self
        tokenField.addBottomBorder(offset: 0.0)
        tokenField.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.registerNib(
            TagSuggestionCollectionViewCell.nib,
            forCellWithReuseIdentifier: TagSuggestionCollectionViewCell.classReuseIdentifier
        )
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newTag != nil ? suggestedTags.count + 1 : suggestedTags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TagSuggestionCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as TagSuggestionCollectionViewCell
        
        var suggestedTag: ProfileService.Containers.Tag?
        if shouldUseNewTag(indexPath) {
            suggestedTag = newTag
        } else {
            suggestedTag = suggestedTags[indexPath.row]
        }
        cell.suggestedTag = suggestedTag
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var tag: ProfileService.Containers.Tag
        if shouldUseNewTag(indexPath) {
            selectedTags.append(newTag!)
        } else {
            selectedTags.append(suggestedTags[indexPath.row])
        }
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
        return CGSizeMake(collectionView.frameWidth, 44.0)
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
            SearchService.Actions.search(text, category: .Skills, attribute: nil, attributeValue: nil, objects: nil) { (result, error) -> Void in
                if (result?.skills != nil) {
                    self.suggestedTags = result!.skills!
                }
                
                var tagBuilder: ProfileService.Containers.TagBuilder
                if self.newTag != nil {
                    tagBuilder = self.newTag!.toBuilder()
                } else {
                    tagBuilder = ProfileService.Containers.Tag.builder()
                    tagBuilder.type = .Skill
                }
                tagBuilder.name = text
                self.newTag = tagBuilder.build()
                self.collectionView.reloadData()
            }
        }
    }
    
    func tokenField(tokenField: TokenField, didEnterText text: String!) {
        selectedTags.append(newTag!)
        newTag = nil
        tokenField.reloadData()
        collectionView.reloadData()
    }
    
    func tokenField(tokenField: TokenField, didDeleteTokenAtIndex index: UInt) {
        selectedTags.removeAtIndex(Int(index))
        tokenField.reloadData()
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
        // TODO check for no tags added
        // TODO only display done button if we have added a tag
        let activityIndicator = view.addActivityIndicator()
        ProfileService.Actions.addTags(AuthViewController.getLoggedInUserProfile()!.id, tags: selectedTags) { (error) in
            if error != nil {
                println("error adding tags: \(error)")
            } else {
                // TODO return any tags that were created so we can add them to the ObjectStore
                self.dismissView()
            }
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
        dismissViewControllerAnimated(true, completion: nil)
    }

}
