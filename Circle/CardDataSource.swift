//
//  CardDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class CardDataSource: NSObject, UICollectionViewDataSource {

    @IBOutlet private(set) var collectionView: UICollectionView!
    
    private var animatedRowIndexes = NSMutableIndexSet()
    // This is set to private(set) because there is no way to do KVO
    // on arrays but the superclass wants to know everytime a card is
    // added or removed. This allows it to encapsulate common functions
    // like registering a particular cell associated with the card, with the 
    // collection view.
    // Subclasses must use appendCard, resetCards, removeCard, 
    // insertCardAtIndex, removeCardAtIndex to manage the data.
    private(set) var cards = [Card]()
    private(set) var isHeaderRegistered = false
    private var registeredCellClasses = NSMutableSet()
    
    func loadData() {
        fatalError("All subclasses need to override this")
    }
    
    func registerCardHeader() {
        collectionView!.registerNib(
            UINib(nibName: "CardHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: CardHeaderCollectionReusableView.classReuseIdentifier
        )
        
        isHeaderRegistered = true
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards[section].content.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let card = cards[indexPath.section]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            card.contentClass.classReuseIdentifier,
            forIndexPath: indexPath
            ) as CircleCollectionViewCell
        
        cell.setData(card.content[indexPath.row])
        animate(cell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: CardHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
            ) as CardHeaderCollectionReusableView
        
        animate(headerView, atIndexPath: indexPath)
        headerView.setCard(cards[indexPath.section])
        return headerView
    }
    
    private func animate(view: UICollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        var uniqueIndex: String
        
        // Unique indexes make sure each item or supplementary view animates only once
        if view is UICollectionViewCell {
            uniqueIndex = String(indexPath.section) + String(indexPath.row)
        }
        else {
            uniqueIndex = String((indexPath.section + 1) * 1000)
        }
        
        let intIndex = uniqueIndex.toInt() ?? 0
        if animatedRowIndexes.containsIndex(intIndex) == false {
            animatedRowIndexes.addIndex(intIndex)
            let finalFrame = view.frame
            view.frameY = finalFrame.origin.y + 40.0
            
            // Delay is based on section index to ensure all components of one section
            // animate in at the same time
            let delay = 0.2 * (Double(indexPath.section) + 1.0)
            view.alpha = 0.0
            
            UIView.animateWithDuration(
                0.5,
                delay: delay,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.6,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    view.frame = finalFrame
                    view.alpha = 1.0
                },
                completion: nil
            )
        }
    }
    
    // MARK: - Cards management
    
    final func appendCard(card: Card) {
        cards.append(card)
        registerReusableCellForCard(card)
    }
    
    final func removeCard(card: Card) {
        if let index = find(cards, card) {
            cards.removeAtIndex(index)
        }
    }
    
    final func insertCard(card: Card, atIndex index: Int) {
        cards.insert(card, atIndex: index)
        registerReusableCellForCard(card)
    }
    
    final func removeCardAtIndex(index: Int) {
        cards.removeAtIndex(index)
    }
    
    final func resetCards() {
        cards.removeAll(keepCapacity: false)
    }
    
    // MARK: - Cell Registration
    
    private func registerReusableCellForCard(card: Card) {
        if !registeredCellClasses.containsObject(card.contentClassName) {
            collectionView.registerNib(
                UINib(nibName: card.contentClassName, bundle: nil),
                forCellWithReuseIdentifier: card.contentClass.classReuseIdentifier
            )
            
            registeredCellClasses.addObject(card.contentClassName)
        }
    }
}
