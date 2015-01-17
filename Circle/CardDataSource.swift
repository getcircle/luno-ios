//
//  CardDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation

class CardDataSource: NSObject, UICollectionViewDataSource {
    
    private var animatedRowIndexes = NSMutableIndexSet()
    /**
    Array for holding data cards. View controllers should access data via this array.
    Each card represents a section and the content attribute of the card holds the row
    data.
    
    This is readonly for everyone (clients and subclasses) because there 
    is no way to do KVO on arrays but the superclass wants to know everytime a card is
    added or removed. This allows it to encapsulate common functions
    like registering a particular cell associated with the card, with the 
    collection view.
    
    Subclasses must use appendCard, resetCards, removeCard, 
    insertCardAtIndex, removeCardAtIndex to manage the data.
    */
    private(set) var cards = [Card]()
    
    /**
    Readonly flag indicating whether a header was registered with the collection view.
    
    This flag can be used by the layout or layout delegate objects to return appropriate sizes for supplementary views.
    */
    private(set) var isHeaderRegistered = false
    private var registeredCellClasses = NSMutableSet()
    var cardHeaderDelegate: CardHeaderViewDelegate?
    
    /**
    This method should be called when the view controller is ready to request for data. This is typically
    in viewWillAppear. The data source class is closely tied to the collection view, so it refreshes
    the collection view on its own once it has the available data.

    Each subclass must override this method. The default implementation does not do anything and it is not
    expected to be called from the subclasses.
    
    :param: completionHandler Closure called when the data or status is available.
    */
    func loadData(completionHandler: (error: NSError?) -> Void) {
        fatalError("All subclasses need to override this")
    }
    
    func setInitialData(content: [AnyObject], ofType: Card.CardType? = .People) {
        fatalError("All subclasses need to override this")
    }
    
    /**
    Registers the default card header supplementary view with the passed in collection view.
    
    :param: collectionView The collection view with which to register the supplementary view with.
    */
    func registerDefaultCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "CardHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: CardHeaderCollectionReusableView.classReuseIdentifier
        )
        
        registerCardHeader(collectionView)
    }
    
    /**
    Register supplementary views with the passed collection view. The default implementation simply sets the internal state.
    This state can then be queried to determine whether to support headers or not from generic layout delegates.
    
    View controllers may choose to register supplementary views but then not actually display them by setting different
    size attributes in the layout directly or via the layout delegate.
    
    Subclasses may override this method to register other custom headers and footers. If they do, the superclass 
    implementation needs to be called as well. In addition to this, subclasses then need to provide the implmentation for
    viewForSupplementaryElementOfKind method.
    
    :param: collectionView The collection view with which to register the supplementary view with.
    */
    func registerCardHeader(collectionView: UICollectionView) {
        isHeaderRegistered = true
    }
    
    /**
    Configure cell instances for display. The default implementation of this method is empty.
    
    This method is called from cellForItemAtIndexPath and from sizeForItemAtIndexPath if the size calculation
    method is Dynamic. This is to make sure prototype cells and real cells are configured exactly the same.

    Subclasses can override this method to further customize cells per instance. The customization should
    be minimum and generally not include fixed layout changes. A good use case of cell configuration would be 
    to hide/show a label within a cell depending on the use case.
    
    :param: cell Cell being configured.
    :param: indexPath Indexpath of the cell.
    */
    func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        // Default Implementation
    }
    
    // MARK: - Collection View Data Source
    
    final func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return cards.count
    }
    
    final func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards[section].content.count
    }
    
    final func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let card = cards[indexPath.section]
        registerReusableCell(collectionView, forCard: card)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            card.contentClass.classReuseIdentifier,
            forIndexPath: indexPath
        ) as CircleCollectionViewCell
        
        cell.card = card
        cell.setData(card.content[indexPath.row])
        configureCell(cell, atIndexPath: indexPath)
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
        if let delegate = cardHeaderDelegate {
            headerView.cardHeaderDelegate = delegate
        }
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
            
            // Delay is based on section index if there are more than one sections else its based on row
            // This ensures cards animate at the same time if there are more than one
            let delayVariable = cards.count > 1 ? indexPath.section : indexPath.row
            let delay = 0.1 * (Double(delayVariable) + 1.0)
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
    }
    
    final func removeCard(card: Card) {
        if let index = find(cards, card) {
            cards.removeAtIndex(index)
        }
    }
    
    final func insertCard(card: Card, atIndex index: Int) {
        cards.insert(card, atIndex: index)
    }
    
    final func removeCardAtIndex(index: Int) {
        cards.removeAtIndex(index)
    }
    
    final func resetCards() {
        cards.removeAll(keepCapacity: false)
    }
    
    // MARK: - Cell Registration
    
    private func registerReusableCell(collectionView: UICollectionView, forCard card: Card) {
        if !registeredCellClasses.containsObject(card.contentClassName) {
            collectionView.registerNib(
                UINib(nibName: card.contentClassName, bundle: nil),
                forCellWithReuseIdentifier: card.contentClass.classReuseIdentifier
            )
            
            registeredCellClasses.addObject(card.contentClassName)
        }
    }
    
    // MARK: - Data Accessors
    
    /**
        Return the card at a particular section.
    
        :param: section Section index.
    
        :returns: Card object or nil.
    */
    func cardAtSection(section: Int) -> Card? {
        return cards[section] ?? nil
    }
    
    /**
        Return the content object at a particular indexPath.
        
        :param: indexPath NSIndexPath.
        
        :returns: AnyObject content object or nil.
    */
    func contentAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        if let card = cards[indexPath.section] as Card? {
            if let content: AnyObject = card.content[indexPath.row] as AnyObject? {
                return content
            }
        }

        return nil
    }
}
