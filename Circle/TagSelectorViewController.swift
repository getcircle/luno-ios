//
//  TagSelectorViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

let reuseIdentifier = "Cell"

class TagSelectorViewController:
    UIViewController,
    UITextFieldDelegate,
    SearchHeaderViewDelegate {

    enum Themes {
        case Onboarding
        case Regular
    }
    
    @IBOutlet weak private(set) var addTagButton: UIButton!
    @IBOutlet weak private(set) var addTagButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var bottomGradientView: UIView!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var doneButton: UIButton!
    @IBOutlet weak private(set) var searchControllerParentView: UIView!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet weak private(set) var titleTextLabel: UILabel!
    @IBOutlet weak private(set) var topGradientView: UIView!
    
    var theme: Themes = .Regular
    
    private var addTagButtonInitialHeight: CGFloat = 0.0
    private var animatedCell = [NSIndexPath: Bool]()
    private var bottomLayer: CAGradientLayer!
    private var cachedItemSizes =  [String: CGSize]()
    private var tags = Array<ProfileService.Containers.Tag>()
    private var filteredTags = Array<ProfileService.Containers.Tag>()
    private var selectedTags = Dictionary<Int, ProfileService.Containers.Tag>()
    private var prototypeCell: TagCollectionViewCell!
    private var searchHeaderView: SearchHeaderView!
    private var topLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tags = ObjectStore.sharedInstance.tags.values.array
        
        // Configurations
        setStatusBarHidden(true)
        configureView()
        configureSearchHeaderView()
        configurePrototypeCell()
        configureCollectionView()
        configureGradients()
        configureAddTagButton()
        configureViewByTheme()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        filteredTags = tags
        collectionView.reloadData()
    }
    
    // MARK: - Configuration

    private func configureView() {
        edgesForExtendedLayout = .Top
        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func configurePrototypeCell() {
        // Init prototype cell
        let cellNibViews = NSBundle.mainBundle().loadNibNamed("TagCollectionViewCell", owner: self, options: nil)
        prototypeCell = cellNibViews.first as TagCollectionViewCell
    }
    
    private func configureCollectionView() {
        collectionView.registerNib(
            UINib(nibName: "TagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: TagCollectionViewCell.classReuseIdentifier
        )
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.allowsMultipleSelection = true
        
    }

    private func configureSearchHeaderView() {
        if let nibViews = NSBundle.mainBundle().loadNibNamed("SearchHeaderView", owner: nil, options: nil) as? [UIView] {
            searchHeaderView = nibViews.first as SearchHeaderView
            searchHeaderView.delegate = self
            searchHeaderView.searchTextField.clearButtonMode = .Always
            searchHeaderView.searchTextField.returnKeyType = .Done
            searchHeaderView.searchTextField.delegate = self
            searchHeaderView.searchTextField.placeholder = NSLocalizedString("Filter tags", comment: "Placeholder text for filter tags input box")
            searchHeaderView.searchTextField.addTarget(self, action: "filter", forControlEvents: .EditingChanged)
            searchControllerParentView.addSubview(searchHeaderView)
            searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            
            switch theme {
            case .Onboarding:
                searchHeaderView.containerBackgroundColor = UIColor.appTintColor()
                searchHeaderView.searchFieldBackgroundColor = UIColor.appTintColor()
                searchHeaderView.searchFieldTintColor = UIColor.whiteColor()
                searchHeaderView.searchFieldTextColor = UIColor.whiteColor()
                searchHeaderView.cancelButton.tintColor = UIColor.whiteColor()
                searchHeaderView.searchTextField.keyboardAppearance = .Dark
                searchHeaderView.updateView()
                
            case .Regular:
                break
            }
        }
    }
    
    private func configureGradients() {
        let startColor = UIColor.appTintColor().CGColor
        let endColor = UIColor.appTintColor().colorWithAlphaComponent(0.0).CGColor
        
        // Top
        topLayer = CALayer.gradientLayerWithFrame(
            topGrientLayerFrame(),
            startColor: startColor,
            endColor: endColor
        )
        topGradientView.layer.addSublayer(topLayer)
        
        // Bottom
        bottomLayer = CALayer.gradientLayerWithFrame(
            bottomGradientLayerFrame(),
            startColor: endColor,
            endColor: startColor
        )
        bottomGradientView.layer.addSublayer(bottomLayer)
    }
    
    private func configureAddTagButton() {
        addTagButtonInitialHeight = addTagButtonHeightConstraint.constant
        addTagButton.setImage(
            addTagButton.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate),
            forState: .Normal
        )

        hideAddTagButton()
    }
    
    private func configureViewByTheme() {
        switch theme {
        case .Onboarding:
            view.backgroundColor = UIColor.appTintColor()
            collectionView.backgroundColor = UIColor.appTintColor()
            searchControllerParentView.backgroundColor = UIColor.appTintColor()
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.backgroundColor = UIColor.appTintColor()
            titleTextLabel.textColor = UIColor.whiteColor()
            titleTextLabel.backgroundColor = UIColor.appTintColor()
            doneButton.backgroundColor = UIColor.appTintColor()
            addTagButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
            addTagButton.setTitleColor(UIColor.appTintColor(), forState: .Normal)
            addTagButton.tintColor = UIColor.appTintColor()

        case .Regular:
            break
        }
    }

    private func configureCellByTheme(cell: TagCollectionViewCell) {
        switch theme {
        case .Onboarding:
            cell.backgroundColor = UIColor.appTintColor()
            cell.defaultTextColor = UIColor.whiteColor()
            cell.defaultBackgroundColor = UIColor.appTintColor()
            cell.defaultBorderColor = UIColor.whiteColor()
            
            cell.highlightedTextColor = UIColor.appTintColor()
            cell.highlightedBackgroundColor = UIColor.whiteColor()
            cell.highlightedBorderColor = UIColor.appTintColor()

        case .Regular:
            break
        }
    }
    
    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTags.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TagCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as TagCollectionViewCell
    
        // Configure the cell
        cell.tagLabel.text = filteredTags[indexPath.row].name.capitalizedString
        configureCellByTheme(cell)
        if animatedCell[indexPath] == nil {
            animatedCell[indexPath] = true
            cell.animateForCollection(collectionView, atIndexPath: indexPath)
        }
        
        // Manage Selection
        let tag = filteredTags[indexPath.row]
        if cell.selected {
            cell.selectCell(false)
        } else if let selectedTag = selectedTags[tag.hashValue] {
            cell.selectCell(false)
            cell.selected = true
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: nil)
        } else {
            cell.unHighlightCell(false)
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.highlightCell(true)
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.unHighlightCell(true)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.selectCell(true)
        let tag = filteredTags[indexPath.row]
        selectedTags[tag.hashValue] = tag
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.unHighlightCell(true)
        let tag = filteredTags[indexPath.row]
        selectedTags[tag.hashValue] = nil
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let tagText = filteredTags[indexPath.row].name.capitalizedString
        if cachedItemSizes[tagText] == nil {
            prototypeCell.tagLabel.text = tagText
            prototypeCell.setNeedsLayout()
            prototypeCell.layoutIfNeeded()
            cachedItemSizes[tagText] = prototypeCell.intrinsicContentSize()
        }
        
        return cachedItemSizes[tagText]!
    }

    // MARK: - IBActions
    
    @IBAction func close(sender: AnyObject!) {
        // fire and forget
        if let profile = AuthViewController.getLoggedInUserProfile() {
            if selectedTags.count > 0 {
                ProfileService.Actions.addTags(profile.id, tags: selectedTags.values.array, completionHandler: nil)
            }
        }
        dismissSearchField()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addTagButtedTapped(sender: AnyObject!) {
        var tagName = searchHeaderView.searchTextField.text
        tagName = tagName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if tagName != "" {
            
            var tagBuilderObject = ProfileService.Containers.Tag.builder()
            tagBuilderObject.name = tagName
            let tag = tagBuilderObject.build()
            
            // Add to source
            // TODO we need to be de-duping these tags
            tags.append(tag)
            selectedTags[tag.hashValue] = tag
            
            // Call filter again
            filter()
            
            // Hide the button
            hideAddTagButton()
        }
    }
    
    // MARK: - SearchHeaderViewDelegate

    func didCancel(sender: UIView) {
        collectionView.reloadData()
    }
    
    // MARK: - SearchHeaderViewDelegate
    
    func filter() {
        let searchString = searchHeaderView.searchTextField.text
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let trimmedString = searchString.stringByTrimmingCharactersInSet(whitespaceCharacterSet).lowercaseString
        if trimmedString == "" {
            filteredTags = tags
            hideAddTagButton()
        }
        else {
            // We need to filter each time from the full set to handle backspace correctly.
            // We used filteredTags to make things specific but that only make sense when adding characters.
            filteredTags = tags.filter({ $0.name.lowercaseString.hasPrefix(trimmedString) })
            showAddTagButton(trimmedString)
        }
        
        if filteredTags.count != tags.count || trimmedString == "" {
            collectionView.reloadData()
        }
    }
    
    // MARK: - UITextFieldDelegate

    func textFieldShouldClear(textField: UITextField) -> Bool {
        collectionView.reloadData()
        
        // If the user hits the clear button when there is no content, the intention most likely
        // is to dismiss the view
        if textField.text == "" {
            dismissSearchField()
        }
        
        hideAddTagButton()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        topGradientView.hidden = true
        bottomGradientView.hidden = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        topGradientView.hidden = false
        bottomGradientView.hidden = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissSearchField()
        collectionView.reloadData()
        hideAddTagButton()
        return true
    }
    
    // MARK: - Helpers
    
    private func topGrientLayerFrame() -> CGRect {
        return CGRectMake(10.0, 0.0, topGradientView.frameWidth - 20.0, 30.0)
    }
    
    private func bottomGradientLayerFrame() -> CGRect {
        return CGRectMake(10.0, 0.0, bottomGradientView.frameWidth - 20.0, 60.0)
    }
    
    private func dismissSearchField() {
        searchHeaderView.searchTextField.text = ""
        searchHeaderView.searchTextField.resignFirstResponder()
    }
    
    private func showAddTagButton(tagName: String) {
        addTagButton.setTitle(
            NSString(format: NSLocalizedString("Add tag \"%@\"", comment: "Button title used when adding a tag with name %@"), tagName),
            forState: .Normal
        )
        addTagButtonHeightConstraint.constant = addTagButtonInitialHeight
        addTagButton.updateConstraints()
        addTagButton.layoutIfNeeded()
    }
    
    private func hideAddTagButton() {
        addTagButtonHeightConstraint.constant = 0.0
        addTagButton.updateConstraints()
        addTagButton.layoutIfNeeded()
    }
}
