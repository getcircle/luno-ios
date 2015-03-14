//
//  SkillSelectorViewController.swift
//  Circle
//
//  Created by Ravi Rani on 12/26/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

let reuseIdentifier = "Cell"

class SkillSelectorViewController:
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
    
    var theme: Themes = .Regular
    
    private var animatedCell = [NSIndexPath: Bool]()
    private var bottomLayer: CAGradientLayer!
    private var cachedItemSizes =  [String: CGSize]()
    private var skills = Array<ProfileService.Containers.Skill>()
    private var filteredSkills = Array<ProfileService.Containers.Skill>()
    private var selectedSkills = Dictionary<Int, ProfileService.Containers.Skill>()
    private var prototypeCell: SkillCollectionViewCell!
    private var searchHeaderView: SearchHeaderView!
    private var topLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skills = ObjectStore.sharedInstance.skills.values.array
        
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
        filteredSkills = skills
        collectionView.reloadData()
    }
    
    // MARK: - Configuration

    private func configureView() {
        edgesForExtendedLayout = .Top
        automaticallyAdjustsScrollViewInsets = true
    }
    
    private func configureNavigationBar() {
        title = AppStrings.AddSkillsNavigationTitle
        
        let doneButtonItem = UIBarButtonItem(
            image: UIImage(named: "CircleCheckFilled"), 
            style: .Plain, 
            target: self, 
            action: "close:"
        )
        navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    private func configurePrototypeCell() {
        // Init prototype cell
        let cellNibViews = NSBundle.mainBundle().loadNibNamed("SkillCollectionViewCell", owner: self, options: nil)
        prototypeCell = cellNibViews.first as SkillCollectionViewCell
    }
    
    private func configureCollectionView() {
        collectionView.registerNib(
            UINib(nibName: "SkillCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: SkillCollectionViewCell.classReuseIdentifier
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
            searchHeaderView.searchTextField.placeholder = AppStrings.TextPlaceholderFilterSkills
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
        let startColor = UIColor.appUIBackgroundColor().CGColor
        let endColor = UIColor.appUIBackgroundColor().colorWithAlphaComponent(0.0).CGColor
        
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
            break
        }
    }

    private func configureCellByTheme(cell: SkillCollectionViewCell) {
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
        return filteredSkills.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            SkillCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as SkillCollectionViewCell
    
        // Configure the cell
        cell.skillLabel.text = filteredSkills[indexPath.row].name
        configureCellByTheme(cell)
        if animatedCell[indexPath] == nil {
            animatedCell[indexPath] = true
            cell.animateForCollection(collectionView, atIndexPath: indexPath)
        }
        
        // Manage Selection
        let skill = filteredSkills[indexPath.row]
        if cell.selected {
            cell.selectCell(false)
        } else if let selectedSkill = selectedSkills[skill.hashValue] {
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
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as SkillCollectionViewCell
        cell.highlightCell(true)
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as SkillCollectionViewCell
        cell.unHighlightCell(true)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as SkillCollectionViewCell
        cell.selectCell(true)
        let skill = filteredSkills[indexPath.row]
        selectedSkills[skill.hashValue] = skill
        if !skill.hasId {
            skills.append(skill)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as SkillCollectionViewCell
        cell.unHighlightCell(true)
        let skill = filteredSkills[indexPath.row]
        selectedSkills[skill.hashValue] = nil
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let skillText = filteredSkills[indexPath.row].name
        if cachedItemSizes[skillText] == nil {
            prototypeCell.skillLabel.text = skillText
            prototypeCell.setNeedsLayout()
            prototypeCell.layoutIfNeeded()
            cachedItemSizes[skillText] = prototypeCell.intrinsicContentSize()
        }
        
        return cachedItemSizes[skillText]!
    }

    // MARK: - IBActions
    
    @IBAction func close(sender: AnyObject!) {
        // fire and forget
        if let profile = AuthViewController.getLoggedInUserProfile() {
            if selectedSkills.count > 0 {
                ProfileService.Actions.addSkills(profile.id, skills: selectedSkills.values.array, completionHandler: nil)
            }
        }
        dismissSearchField()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func getNewSkillObject() -> ProfileService.Containers.Skill? {
        var skillName = searchHeaderView.searchTextField.text
        skillName = skillName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if skillName != "" {
            var skillBuilderObject = ProfileService.Containers.Skill.builder()
            skillBuilderObject.name = skillName
            return skillBuilderObject.build()
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
            filteredSkills = skills
        }
        else {
            DebugUtils.measure("Filter", call: { () -> Void in
                // We need to filter each time from the full set to handle backspace correctly.
                // We used filteredSkills to make things specific but that only make sense when adding characters.
                self.filteredSkills = self.skills.filter({ $0.name.lowercaseString.hasPrefix(trimmedString) })
                let exactMatchSkills = self.skills.filter({ $0.name.lowercaseString == trimmedString })
                if exactMatchSkills.count == 0 {
                    if let newSkill = self.getNewSkillObject() {
                        self.filteredSkills.insert(newSkill, atIndex: 0)
                    }
                }
            })
        }
        
        if filteredSkills.count != skills.count || trimmedString == "" {
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
}
