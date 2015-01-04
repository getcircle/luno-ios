//
//  CardCollectionViewDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 1/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class CardCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    weak var delegate: UICollectionViewDelegate?
    private var prototypeCellsHolder = [String: CircleCollectionViewCell]()
    
    // MARK: - Flow Layout Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        let card = cardDataSource(collectionView).cards[section]
        return card.contentClass.interItemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        let card = cardDataSource(collectionView).cards[section]
        return card.contentClass.lineSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let card = cardDataSource(collectionView).cards[section]
        return card.contentClass.sectionInset
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // Use default width and height methods if size calculation method of choice is Fixed
        let card = cardDataSource(collectionView).cards[indexPath.section]
        if card.contentClass.sizeCalculationMethod == SizeCalculation.Fixed {
            var leftAndRightInsets = card.contentClass.sectionInset.left
            leftAndRightInsets += card.contentClass.sectionInset.right
            return CGSizeMake(card.contentClass.width - leftAndRightInsets, card.contentClass.height)
        }
        else {
            
            // Use a prototype cell if size calculation method of choice is Dynamic
            // Instantiate a prototype cell and cache it for later use
            if prototypeCellsHolder[card.title] == nil {
                let cellNibViews = NSBundle.mainBundle().loadNibNamed(card.contentClassName, owner: self, options: nil)
                prototypeCellsHolder[card.title] = cellNibViews.first as? CircleCollectionViewCell
            }
            
            if let prototypeCell = prototypeCellsHolder[card.title] {
                prototypeCell.setData(card.content[indexPath.row])
                prototypeCell.setNeedsLayout()
                prototypeCell.layoutIfNeeded()
                return prototypeCell.intrinsicContentSize()
            }
        }
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if !cardDataSource(collectionView).isHeaderRegistered {
            return CGSizeZero
        }

        return CGSizeMake(collectionView.frameWidth, CardHeaderCollectionReusableView.height)
    }
    
    // MARK: - UICollectionViewDelegate
 
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.collectionView?(collectionView, didSelectItemAtIndexPath: indexPath)
    }
    
    // MARK: - ScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    
    // MARK: - Helpers
    
    private func cardDataSource(collectionView: UICollectionView) -> CardDataSource {
        return (collectionView.dataSource as CardDataSource)
    }
}