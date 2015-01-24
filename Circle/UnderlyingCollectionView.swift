//
//  UnderlyingCollectionView.swift
//  Circle
//
//  Created by Michael Hahn on 1/22/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

@objc protocol UnderlyingCollectionViewDelegate {
    optional func underlyingCollectionViewDidBeginScrolling(collectionView: UICollectionView)
    optional func underlyingCollectionViewDidChangeContentOffset(collectionView: UICollectionView, offset: CGFloat)
    optional func underlyingCollectionViewDidEndScrolling(collectionView: UICollectionView)
}

class UnderlyingCollectionView: UICollectionView, UICollectionViewDelegate {
    
    override var delegate: UICollectionViewDelegate? {
        didSet {
            if let cardCollectionViewDelegate = delegate as CardCollectionViewDelegate? {
                cardCollectionViewDelegate.delegate = self
            }
        }
    }
    var externalScrollDelegate: UnderlyingCollectionViewDelegate?
    
    // Delegate helper variables
    private var scrolling = false
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        
        if !scrolling {
            externalScrollDelegate?.underlyingCollectionViewDidBeginScrolling?(self)
            scrolling = true
        }
        
        if scrolling {
            externalScrollDelegate?.underlyingCollectionViewDidChangeContentOffset?(self, offset: offset)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollingEnded()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollingEnded()
    }
    
    private func scrollingEnded() {
        externalScrollDelegate?.underlyingCollectionViewDidEndScrolling?(self)
        scrolling = false
    }
    
}
