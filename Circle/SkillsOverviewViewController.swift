//
//  SkillsOverviewViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SkillsOverviewViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    private(set) var dataSource = SkillsOverviewDataSource()
    
    private var prototypeCell: SkillCollectionViewCell!
    private var cachedItemSizes = [String: CGSize]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureCollectionView()
        configurePrototypeCell()
    }

    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.viewBackgroundColor()
    }
    
    private func configurePrototypeCell() {
        // Init prototype cell
        let cellNibViews = NSBundle.mainBundle().loadNibNamed("SkillCollectionViewCell", owner: self, options: nil)
        prototypeCell = cellNibViews.first as SkillCollectionViewCell
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.whiteColor()
        // Header
        collectionView.registerNib(
            UINib(nibName: "SearchResultsCardHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: SearchResultsCardHeaderCollectionReusableView.classReuseIdentifier
        )

        // Footer
        collectionView.registerClass(
            SeparatorDecorationView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
            withReuseIdentifier: SeparatorDecorationView.classReuseIdentifier
        )
        
        // Item
        collectionView.registerNib(
            UINib(nibName: "SkillCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: SkillCollectionViewCell.classReuseIdentifier
        )
        
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = dataSource
    }
    
    // MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let selectedSkill = dataSource.skill(collectionView: collectionView, atIndexPath: indexPath) {
            let viewController = SkillDetailViewController()
            (viewController.dataSource as SkillDetailDataSource).selectedSkill = selectedSkill
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let skill = dataSource.skill(collectionView: collectionView, atIndexPath: indexPath) {
            let skillText = skill.name.capitalizedString
            if cachedItemSizes[skillText] == nil {
                prototypeCell.skillLabel.text = skillText
                prototypeCell.setNeedsLayout()
                prototypeCell.layoutIfNeeded()
                cachedItemSizes[skillText] = prototypeCell.intrinsicContentSize()
            }
            
            return cachedItemSizes[skillText]!
        }
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSizeMake(view.frameWidth, SearchResultsCardHeaderCollectionReusableView.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSizeMake(view.frameWidth, 1.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10.0, 15.0, 15.0, 15.0)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 14.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
}
