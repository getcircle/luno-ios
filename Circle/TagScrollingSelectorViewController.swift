//
//  TagScrollingSelectorViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

let reuseIdentifier = "Cell"

class TagScrollingSelectorViewController:
    UIViewController,
    UITextFieldDelegate,
    SearchHeaderViewDelegate {

    enum Themes {
        case Onboarding
        case Regular
    }
    
    @IBOutlet weak private(set) var bottomGradientView: UIView!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var searchControllerParentView: UIView!
    @IBOutlet weak private(set) var titleTextLabel: UILabel!
    @IBOutlet weak private(set) var topGradientView: UIView!
    
    var addNextButton: Bool = false
    var theme: Themes = .Regular
    var preSelectTags: Array<Services.Profile.Containers.TagV1> = Array<ProfileService.Containers.Tag>() {
        didSet {
            for interest in preSelectTags {
                selectedTags[interest.hashValue] = interest
            }
        }
    }
    
    private var animatedCell = [NSIndexPath: Bool]()
    private var bottomLayer: CAGradientLayer!
    private var cachedItemSizes =  [String: CGSize]()
    private var filteredTags = Array<Services.Profile.Containers.TagV1>()
    private var interests = Array<Services.Profile.Containers.TagV1>()
    private var selectedTags = Dictionary<Int, Services.Profile.Containers.TagV1>()
    private var prototypeCell: TagCollectionViewCell!
    private var searchHeaderView: SearchHeaderView!
    private var topLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interests = ObjectStore.sharedInstance.interests.values.array
        
        // Configurations
        configureView()
        configureNavigationBar()
        configureSearchHeaderView()
        configurePrototypeCell()
        configureCollectionView()
        configureGradients()
        configureViewByTheme()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        filteredTags = interests
        collectionView.reloadData()
    }
    
    // MARK: - Configuration

    private func configureView() {
        edgesForExtendedLayout = .Top
        automaticallyAdjustsScrollViewInsets = true
        extendedLayoutIncludesOpaqueBars = true
    }
    
    private func configureNavigationBar() {
        title = AppStrings.AddTagsNavigationTitle
        if addNextButton {
            addNextButtonWithAction("save:")
        }
        else {
            addDoneButtonWithAction("save:")
        }

        addCloseButtonWithAction("cancel:")
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
            searchHeaderView.searchTextField.addBottomBorder()
            searchHeaderView.searchTextField.autocapitalizationType = .Words
            searchHeaderView.searchTextField.clearButtonMode = .Always
            searchHeaderView.searchTextField.returnKeyType = .Done
            searchHeaderView.searchTextField.delegate = self
            searchHeaderView.searchTextField.placeholder = AppStrings.TextPlaceholderFilterTags
            searchHeaderView.searchTextField.addTarget(self, action: "filter", forControlEvents: .EditingChanged)
            searchHeaderView.searchTextFieldHeightConstraint.constant = searchControllerParentView.frameHeight
            searchControllerParentView.addSubview(searchHeaderView)
            searchHeaderView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            
            switch theme {
            case .Onboarding:
                searchHeaderView.searchTextField.placeholderColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
                searchHeaderView.containerBackgroundColor = UIColor.appUIBackgroundColor()
                searchHeaderView.searchFieldBackgroundColor = UIColor.appUIBackgroundColor()
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
        var startColor: CGColor
        var endColor: CGColor
        
        switch theme {
        case .Onboarding:
            startColor = UIColor.appUIBackgroundColor().CGColor
            endColor = UIColor.appUIBackgroundColor().colorWithAlphaComponent(0.0).CGColor

        case .Regular:
            startColor = UIColor.appViewBackgroundColor().CGColor
            endColor = UIColor.appViewBackgroundColor().colorWithAlphaComponent(0.0).CGColor
        }
        
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

    private func configureViewByTheme() {
        switch theme {
        case .Onboarding:
            view.backgroundColor = UIColor.appUIBackgroundColor()
            collectionView.backgroundColor = UIColor.appUIBackgroundColor()
            searchControllerParentView.backgroundColor = UIColor.appUIBackgroundColor()
            titleTextLabel.textColor = UIColor.whiteColor()
            titleTextLabel.backgroundColor = UIColor.appUIBackgroundColor()

        case .Regular:
            view.backgroundColor = UIColor.appViewBackgroundColor()
            collectionView.backgroundColor = UIColor.appViewBackgroundColor()
            break
        }
    }

    private func configureCellByTheme(cell: TagCollectionViewCell) {
        switch theme {
        case .Onboarding:
            cell.backgroundColor = UIColor.appUIBackgroundColor()
            cell.defaultTextColor = UIColor.whiteColor()
            cell.defaultBackgroundColor = UIColor.appUIBackgroundColor()
            cell.defaultBorderColor = UIColor.whiteColor()
            
            cell.highlightedTextColor = UIColor.appUIBackgroundColor()
            cell.highlightedBackgroundColor = UIColor.whiteColor()
            cell.highlightedBorderColor = UIColor.appUIBackgroundColor()

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
        cell.interestLabel.text = filteredTags[indexPath.row].name
        configureCellByTheme(cell)
        if animatedCell[indexPath] == nil {
            animatedCell[indexPath] = true
            cell.animateForCollection(collectionView, atIndexPath: indexPath)
        }
        
        // Manage Selection
        let interest = filteredTags[indexPath.row]
        if cell.selected {
            cell.selectCell(false)
        } else if let selectedTag = selectedTags[interest.hashValue] {
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
        let interest = filteredTags[indexPath.row]
        selectedTags[interest.hashValue] = interest
        if !interest.hasId {
            interests.append(interest)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as TagCollectionViewCell
        cell.unHighlightCell(true)
        let interest = filteredTags[indexPath.row]
        selectedTags[interest.hashValue] = nil
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let interestText = filteredTags[indexPath.row].name
        if cachedItemSizes[interestText] == nil {
            prototypeCell.interestLabel.text = interestText
            prototypeCell.setNeedsLayout()
            prototypeCell.layoutIfNeeded()
            cachedItemSizes[interestText] = prototypeCell.intrinsicContentSize()
        }
        
        return cachedItemSizes[interestText]!
    }

    // MARK: - IBActions
    
    @IBAction func save(sender: AnyObject!) {
        // fire and forget
        if let profile = AuthViewController.getLoggedInUserProfile() {
            if selectedTags.count > 0 {
                ProfileService.Actions.addTags(profile.id, tags: selectedTags.values.array, completionHandler: nil)
            }
        }

        dismissView()
    }

    @IBAction func cancel(sender: AnyObject!) {
        dismissView()
    }
    
    private func getNewTagObject() -> Services.Profile.Containers.TagV1? {
        var interestName = searchHeaderView.searchTextField.text
        interestName = interestName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if interestName != "" {
            var interestBuilderObject = Services.Profile.Containers.TagV1.builder()
            interestBuilderObject.name = interestName
            return interestBuilderObject.build()
        }
        
        return nil
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
            filteredTags = interests
        }
        else {
            DebugUtils.measure("Filter", call: { () -> Void in
                // We need to filter each time from the full set to handle backspace correctly.
                // We used filteredTags to make things specific but that only make sense when adding characters.
                self.filteredTags = self.interests.filter({ $0.name.lowercaseString.hasPrefix(trimmedString) })
                let exactMatchTags = self.interests.filter({ $0.name.lowercaseString == trimmedString })
                if exactMatchTags.count == 0 {
                    if let newTag = self.getNewTagObject() {
                        self.filteredTags.insert(newTag, atIndex: 0)
                    }
                }
            })
        }
        
        if filteredTags.count != interests.count || trimmedString == "" {
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
    
    private func dismissView() {
        dismissSearchField()
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
