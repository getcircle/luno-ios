//
//  SpringFlowLayout.swift
//  Circle
//
//  Created by Michael Hahn on 11/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class SpringFlowLayout: UICollectionViewFlowLayout {
    
    private(set) var dynamicAnimator: UIDynamicAnimator?
    var scrollResistanceFactor: CGFloat = 900.0
    
    private var visibleIndexPathsSet = NSMutableSet()
    private var visibleHeaderAndFooterSet = NSMutableSet()
    private var latestDelta: CGFloat = 0
    private var interfaceOrientation: UIInterfaceOrientation?
    
    override init() {
        super.init()
        configure()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    override func prepareLayout() {
        
        let statusBarOrientation = UIApplication.sharedApplication().statusBarOrientation
        // reset layout on device rotation
        if statusBarOrientation != interfaceOrientation {
            dynamicAnimator?.removeAllBehaviors()
            visibleIndexPathsSet = NSMutableSet()
        }
        
        interfaceOrientation = statusBarOrientation
        // Overflow the actual rect slightly to avoid flickering
        let visibleRect = CGRectInset(collectionView!.bounds, -100, -100)
        let itemsInVisibleRect = super.layoutAttributesForElementsInRect(visibleRect) as [UICollectionViewLayoutAttributes]
        let itemsIndexPathsInVisibleRect = NSSet(array: itemsInVisibleRect.map { item in item.indexPath })
        
        // Step 1: Remove any behaviors that are no longer visible
        let noLongerVisibleBehaviors = dynamicAnimator?.behaviors.filter { behavior in
            if let firstItem: AnyObject = behavior.items?.first {
                return !itemsIndexPathsInVisibleRect.containsObject(firstItem.indexPath)
            }
            return true
        } as [UIAttachmentBehavior]
        
        for behavior in noLongerVisibleBehaviors {
            dynamicAnimator?.removeBehavior(behavior)
            if let firstItem: AnyObject = behavior.items.first {
                visibleIndexPathsSet.removeObject(firstItem.indexPath)
                visibleHeaderAndFooterSet.removeObject(firstItem.indexPath)
            }
        }
        
        // Step 2: Add any newly visible behaviors
        // A "newly visible" item is one that is in the itemsInVisibleRect but not in the visibleIndexPathsSet
        let newlyVisibleItems = itemsInVisibleRect.filter { attributes in
            var visible: Bool
            if attributes.representedElementCategory == .Cell {
                visible = self.visibleIndexPathsSet.containsObject(attributes.indexPath)
            } else {
                visible = self.visibleHeaderAndFooterSet.containsObject(attributes.indexPath)
            }
            return !visible
        }
        
        let touchPoint = getTouchPoint()
        
        for attributes in newlyVisibleItems {
            var center = attributes.center
            let springBehavior = UIAttachmentBehavior(item: attributes, attachedToAnchor: center)
            
            springBehavior.length = 1.0
            springBehavior.damping = 0.8
            springBehavior.frequency = 1.0
            
            // If our touchPoint is not (0, 0) we'll need to adjust our item's center "in flight"
            if !CGPointEqualToPoint(CGPointZero, touchPoint) {
                if scrollDirection == .Vertical {
                    let distanceFromTouch = getDistanceAsNumber(touchPoint.y, second: springBehavior.anchorPoint.y)
                    
                    let scrollResistance = CGFloat(distanceFromTouch) / scrollResistanceFactor
                    if latestDelta < 0 {
                        center.y += max(latestDelta, latestDelta * scrollResistance)
                    } else {
                        center.y += min(latestDelta, latestDelta * scrollResistance)
                    }
                    
                    attributes.center = center
                } else {
                    let distanceFromTouch = getDistanceAsNumber(touchPoint.x, second: springBehavior.anchorPoint.x)
                    
                    let scrollResistance = CGFloat(distanceFromTouch) / scrollResistanceFactor
                    if latestDelta < 0 {
                        center.x += max(latestDelta, latestDelta * scrollResistance)
                    } else {
                        center.x += min(latestDelta, latestDelta * scrollResistance)
                    }
                    
                    attributes.center = center
                }
            }
            
            dynamicAnimator?.addBehavior(springBehavior)
            if attributes.representedElementCategory == .Cell {
                visibleIndexPathsSet.addObject(attributes.indexPath)
            } else {
                visibleHeaderAndFooterSet.addObject(attributes.indexPath)
            }
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return dynamicAnimator?.itemsInRect(rect)
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        if let attributes = dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath) {
            return attributes
        } else {
            return super.layoutAttributesForItemAtIndexPath(indexPath)
        }
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        if let scrollView: UIScrollView = collectionView {
            var delta: CGFloat
            if scrollDirection == .Vertical {
                delta = newBounds.origin.y - scrollView.bounds.origin.y
            } else {
                delta = newBounds.origin.x - scrollView.bounds.origin.x
            }
            latestDelta = delta
            
            let touchPoint = getTouchPoint()
            
            for springBehavior in dynamicAnimator?.behaviors as [UIAttachmentBehavior] {
                if scrollDirection == .Vertical {
                    let distanceFromTouch = getDistanceAsNumber(touchPoint.y, second: springBehavior.anchorPoint.y)
                    
                    let scrollResistance = CGFloat(distanceFromTouch) / scrollResistanceFactor
                    let attributes = springBehavior.items.first as UICollectionViewLayoutAttributes
                    var center = attributes.center
                    if delta < 0 {
                        center.y += max(delta, delta * scrollResistance)
                    } else {
                        center.y += min(delta, delta * scrollResistance)
                    }
                    attributes.center = center
                    dynamicAnimator?.updateItemUsingCurrentState(attributes)
                } else {
                    let distanceFromTouch = getDistanceAsNumber(touchPoint.x, second: springBehavior.anchorPoint.x)
                    
                    let scrollResistance = CGFloat(distanceFromTouch) / scrollResistanceFactor
                    let attributes = springBehavior.items.first as UICollectionViewLayoutAttributes
                    var center = attributes.center
                    if delta < 0 {
                        center.x += max(delta, delta * scrollResistance)
                    } else {
                        center.x += min(delta, delta * scrollResistance)
                    }
                    attributes.center = center
                    dynamicAnimator?.updateItemUsingCurrentState(attributes)
                }
            }
        }
        return false
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        for item in updateItems as [UICollectionViewUpdateItem] {
            if item.updateAction == .Insert {
                if (dynamicAnimator?.layoutAttributesForCellAtIndexPath(item.indexPathAfterUpdate) != nil) {
                    return
                }
                
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: item.indexPathAfterUpdate)
                let springBehavior = UIAttachmentBehavior(item: attributes, attachedToAnchor: attributes.center)
                
                springBehavior.length = 1.0
                springBehavior.damping = 0.8
                springBehavior.frequency = 1.0
                dynamicAnimator?.addBehavior(springBehavior)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func getTouchPoint() -> CGPoint {
        return collectionView?.panGestureRecognizer.locationInView(collectionView) ?? CGPointZero
    }
    
    private func getDistanceAsNumber(first: CGFloat, second: CGFloat) -> NSNumber {
        return NSNumber(float: fabsf(Float(first) - Float(second)))
    }
}
