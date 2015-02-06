//
//  SkillsCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

struct SkillsCollectionViewCellNotifications {
    static let onSkillSelectedNotification = "com.ravcode.notification:onSkillSelectedNotification"
}

class SkillsCollectionViewCell: CircleCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    override class var classReuseIdentifier: String {
        return "SkillsCollectionViewCell"
    }

    override class var height: CGFloat {
        return 90.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private var collectionViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak private var skillsLabel: UILabel!
    
    var prototypeCell: SkillCollectionViewCell!
    var showSkillsLabel: Bool = false {
        didSet {
            if showSkillsLabel {
                skillsLabel.hidden = false
                collectionViewTopSpaceConstraint.constant = 31.0
            }
            else {
                skillsLabel.hidden = true
                collectionViewTopSpaceConstraint.constant = 0.0
            }
        }
    }
    
    // pass backgroundColor changes to the collectionView
    override var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = backgroundColor
            collectionView?.backgroundColor = backgroundColor
        }
    }
    
    var selectedSkill: ProfileService.Containers.Skill?
    private var skills = Array<ProfileService.Containers.Skill>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        showSkillsLabel = false
        configureCollectionView()
        configurePrototypeCell()
        selectedBackgroundView = nil
    }

    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.bounces = false
        collectionView.registerNib(
            UINib(nibName: "SkillCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: SkillCollectionViewCell.classReuseIdentifier
        )
    }
    
    private func configurePrototypeCell() {
        // Init prototype cell
        let cellNibViews = NSBundle.mainBundle().loadNibNamed("SkillCollectionViewCell", owner: self, options: nil)
        prototypeCell = cellNibViews.first as SkillCollectionViewCell
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skills.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let skill = skills[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            SkillCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as SkillCollectionViewCell
        
        cell.skillLabel.text = skill.name
        cell.skillLabel.backgroundColor = collectionView.backgroundColor
        cell.backgroundColor = collectionView.backgroundColor
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let skill = skills[indexPath.row]

        prototypeCell.skillLabel.text = skill.name
        prototypeCell.setNeedsLayout()
        prototypeCell.layoutIfNeeded()
        let intrinsicSize = prototypeCell.intrinsicContentSize()
        return CGSizeMake(intrinsicSize.width, 28.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if showSkillsLabel {
            // Algin skills with the label if the label is shown
            return UIEdgeInsetsMake(10.0, skillsLabel.frameX, 10.0, skillsLabel.frameX)
        }
        else {
            return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        }
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let skill = skills[indexPath.row]
        selectedSkill = skill
        NSNotificationCenter.defaultCenter().postNotificationName(
            SkillsCollectionViewCellNotifications.onSkillSelectedNotification,
            object: nil,
            userInfo: ["skill": skill]
        )
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        selectedSkill = nil
    }
    
    // MARK: - Data Setter
    
    override func setData(data: AnyObject) {
        if let arrayOfSkills = data as? [ProfileService.Containers.Skill] {
            skills = arrayOfSkills
            collectionView.reloadData()
        }
    }
    
    // MARK: - Sizing
    
    override func intrinsicContentSize() -> CGSize {
        let collectionViewLayout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        let height = collectionViewLayout.collectionViewContentSize().height + collectionViewTopSpaceConstraint.constant
        return CGSizeMake(CircleCollectionViewCell.width, height)
    }
}
