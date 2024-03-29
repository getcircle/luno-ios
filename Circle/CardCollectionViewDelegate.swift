//
//  CardCollectionViewDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 1/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import UIKit

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
        return card.sectionInset
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // Use default width and height methods if size calculation method of choice is Fixed
        let dataSource = cardDataSource(collectionView)
        let card = dataSource.cards[indexPath.section]
        var leftAndRightInsets: CGFloat
        if card.contentClass.sizeIncludesInsets {
            leftAndRightInsets = 0.0
        } else {
            leftAndRightInsets = card.sectionInset.left
            leftAndRightInsets += card.sectionInset.right
        }

        if card.contentClass.sizeCalculationMethod == SizeCalculation.Fixed {
            let width = min(card.contentClass.width, collectionView.frame.width)
            return CGSizeMake(width - leftAndRightInsets, card.contentClass.height)
        }
        else {
            
            // Use a prototype cell if size calculation method of choice is Dynamic
            // Instantiate a prototype cell and cache it for later use
            if prototypeCellsHolder[card.contentClassName] == nil {
                let cellNibViews = NSBundle.mainBundle().loadNibNamed(card.contentClassName, owner: self, options: nil)
                prototypeCellsHolder[card.contentClassName] = cellNibViews.first as? CircleCollectionViewCell
            }
            
            if let prototypeCell = prototypeCellsHolder[card.contentClassName] {
                prototypeCell.setData(card.content[indexPath.row])
                dataSource.configureCell(prototypeCell, atIndexPath: indexPath)
                prototypeCell.setNeedsLayout()
                prototypeCell.layoutIfNeeded()
                let intrinsicCellSize = prototypeCell.intrinsicContentSize()
                return CGSizeMake(intrinsicCellSize.width - leftAndRightInsets, intrinsicCellSize.height)
            }
        }
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let card = cardDataSource(collectionView).cardAtSection(section) {
            if card.addHeader {
                return card.headerSize
            }
        }

        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if let card = cardDataSource(collectionView).cardAtSection(section) {
            if card.addFooter {
                return card.footerSize
            }
        }
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView,
        didEndDisplayingSupplementaryView view: UICollectionReusableView,
        forElementOfKind elementKind: String,
        atIndexPath indexPath: NSIndexPath) {
        delegate?.collectionView?(
            collectionView,
            didEndDisplayingSupplementaryView: view,
            forElementOfKind: elementKind,
            atIndexPath: indexPath
        )
    }
    
    // MARK: - UICollectionViewDelegate
 
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.collectionView?(collectionView, didSelectItemAtIndexPath: indexPath)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - ScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        delegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    // MARK: - Helpers
    
    func cardDataSource(collectionView: UICollectionView) -> CardDataSource {
        return (collectionView.dataSource as! CardDataSource)
    }
}
