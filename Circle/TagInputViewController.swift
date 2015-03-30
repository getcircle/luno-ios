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
    VENTokenFieldDelegate,
    VENTokenFieldDataSource
{

    @IBOutlet private(set) weak var tokenField: VENTokenField!
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet private(set) weak var emptyCollectionView: UIView!
    @IBOutlet weak var tokenFieldHeightConstraint: NSLayoutConstraint!
    
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
        view.backgroundColor = UIColor.appViewBackgroundColor()
    }
    
    private func configureNavigationBar() {
        title = AppStrings.ProfileSectionExpertiseTitle
        addDoneButtonWithAction("done:")
        addCloseButtonWithAction("cancel:")
    }
    
    private func configureTokenField() {
        tokenField.removeConstraint(tokenFieldHeightConstraint)
        tokenField.dataSource = self
        tokenField.delegate = self
        tokenField.addRoundCorners()
        tokenField.placeholderText = NSLocalizedString(
            "Enter skills and expertise...",
            comment: "Placeholder text indicating field where skills and expertise should be added."
        )
        tokenField.labelFont = UIFont.appTagTokenFont()
        tokenField.tokenBackgroundColor = UIColor.lightGrayColor()
        tokenField.tokenTextColor = UIColor.whiteColor()
        tokenField.tokenHighlightedTextColor = UIColor.whiteColor()
        tokenField.tokenHighlightedBackgroundColor = UIColor.appTintColor()
        tokenField.tokenPadding = 10.0
        tokenField.toLabel.hidden = true
        tokenField.appendDelimiterToToken = false
    }
    
    private func configureCollectionView() {
        emptyCollectionView.backgroundColor = UIColor.appViewBackgroundColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        collectionView.alwaysBounceVertical = true
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
        setShouldDisplayEmptyCollectionView(true)
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frameWidth, 44.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }

    // MARK: - VENTokenFieldDelegate
    
    func tokenFieldDidBeginEditing(tokenField: VENTokenField!) {
        // TODO hide initial copy view
    }
    
    func tokenField(tokenField: VENTokenField!, didEnterText text: String!) {
        addNewTagToSet {
            self.collectionView.reloadData()
        }
    }
    
    func tokenField(tokenField: VENTokenField!, didChangeText text: String!) {
        // TODO show copy view if empty
        if text == "" {
            newTag = nil
            suggestedTags.removeAll(keepCapacity: false)
            collectionView.reloadData()
            setShouldDisplayEmptyCollectionView(true)
        } else {
            setShouldDisplayEmptyCollectionView(false)
            SearchService.Actions.search(text, category: .Skills, attribute: nil, attributeValue: nil, objects: nil) { (result, error) -> Void in
                if (result?.skills != nil) {
                    self.suggestedTags = result!.skills!
                }
                
                var tagBuilder: ProfileService.Containers.TagBuilder
                if self.newTag != nil {
                    tagBuilder = self.newTag!.toBuilder()
                } else {
                    tagBuilder = ProfileService.Containers.Tag.builder()
                }
                tagBuilder.name = text
                self.newTag = tagBuilder.build()
                self.collectionView.reloadData()
            }
        }
    }
    
    func tokenField(tokenField: VENTokenField!, didDeleteTokenAtIndex index: UInt) {
        selectedTags.removeAtIndex(Int(index))
        tokenField.reloadData()
    }
    
    // MARK - VENTokenFieldDataSource
    
    func tokenField(tokenField: VENTokenField!, titleForTokenAtIndex index: UInt) -> String! {
        return selectedTags[Int(index)].name
    }
    
    func numberOfTokensInTokenField(tokenField: VENTokenField!) -> UInt {
        return UInt(selectedTags.count)
    }
    
    // MARK: - IBActions
    
    @IBAction func done(sender: AnyObject!) {
        // TODO send to backend
        println("add the following expertise to the person: \(selectedTags)")
        dismissView()
    }
    
    @IBAction func cancel(sender: AnyObject!) {
        dismissView()
    }
    // MARK: - Helpers
    
    private func shouldUseNewTag(indexPath: NSIndexPath) -> Bool {
        return (indexPath.row + 1) > suggestedTags.count
    }
    
    private func addNewTagToSet(completion: () -> Void) {
        selectedTags.append(newTag!)
        newTag = nil
        tokenField.reloadData()
        completion()
    }
    
    private func dismissView() {
        tokenField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setShouldDisplayEmptyCollectionView(shouldDisplay: Bool) {
        emptyCollectionView.hidden = !shouldDisplay
    }
}
