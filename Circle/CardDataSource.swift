//
//  CardDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

class ItemImage {
    var name: String
    var tint: UIColor
    var size: CGSize?
    
    class var genericNextImage: ItemImage {
        return ItemImage(name: "Next", tint: UIColor.appKeyValueNextImageTintColor(), size: CGSizeMake(15.0, 15.0))
    }
    
    init(name itemName: String, tint itemTint: UIColor, size imageSize: CGSize? = nil) {
        name = itemName
        tint = itemTint
        size = imageSize
    }
}

enum ContentType: Int {
    case About = 1
    case Birthday
    case CellPhone
    case Education
    case Email
    case Facebook
    case Github
    case HireDate
    case LinkedIn
    case LinkedInConnect
    case Manager
    case Office
    case OfficeTeam
    case Other
    case PeopleCount
    case Position
    case SeatingInfo
    case Skills
    case Team
    case Twitter
    case QuickActions
    case WorkPhone
}

class SectionItem {
    var title: String
    var image: ItemImage?
    var container: String
    var containerKey: String
    var contentType: ContentType!
    var defaultValue: Any?
    
    init(
        title itemTitle: String,
        container itemContainer: String,
        containerKey itemContainerKey: String,
        contentType type: ContentType,
        image itemImage: ItemImage?,
        defaultValue itemDefaultValue: Any? = nil
        ) {
            title = itemTitle
            container = itemContainer
            containerKey = itemContainerKey
            image = itemImage
            contentType = type
            defaultValue = itemDefaultValue
    }
}

class Section {
    var title: String
    var items: [SectionItem]
    var cardType: Card.CardType
    var cardHeaderSize: CGSize
    
    init(
        title sectionTitle: String,
        items sectionItems: [SectionItem],
        cardType sectionCardType: Card.CardType,
        cardHeaderSize sectionCardHeaderSize: CGSize = CGSizeZero
        ) {
            title = sectionTitle
            items = sectionItems
            cardType = sectionCardType
            cardHeaderSize = sectionCardHeaderSize
    }
}

class CardDataSource: NSObject, UICollectionViewDataSource {
    
    enum TypeOfView {
        case Cell
        case Footer
        case Header
    }
    
    var animateContent = false
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
    Footer view delegate.
    */
    var cardFooterDelegate: CardFooterViewDelegate?
    private(set) var isFooterRegistered = false
    private var registeredFooterClasses = NSMutableSet()

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
    
    func setInitialData(content: [AnyObject], ofType: Card.CardType? = .Profiles) {
        fatalError("All subclasses need to override this")
    }
    
    func setInitialData(#content: [AnyObject], ofType: Card.CardType? = .Profiles, withMetaData metaData:AnyObject? = nil) {
        fatalError("All subclasses need to override this")
    }
    
    func setInitialData(#content: [AnyObject], ofType: Card.CardType? = .Profiles, nextRequest withNextRequest: ServiceRequest?) {
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
        let percentContent = Float(indexPath.row) / Float(card.content.count) * 100
        registerReusableCell(collectionView, forCard: card)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            card.contentClass.classReuseIdentifier,
            forIndexPath: indexPath
        ) as CircleCollectionViewCell
        
        cell.card = card
        cell.setData(card.content[indexPath.row])
        configureCell(cell, atIndexPath: indexPath)
        animate(cell, ofType: .Cell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let card = cards[indexPath.section]
        
        if kind == UICollectionElementKindSectionFooter && card.addFooter {
            return addDefaultFooterView(collectionView, atIndexPath: indexPath)
        }
        else {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: CardHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as CardHeaderCollectionReusableView
            
            animate(headerView, ofType: .Header, atIndexPath: indexPath)
            if let delegate = cardHeaderDelegate {
                headerView.cardHeaderDelegate = delegate
            }
            headerView.setCard(card)
            return headerView
        }
    }
    
    final func addDefaultFooterView(collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let card = cards[indexPath.section]
        registerReusableFooter(collectionView, forCard: card)
        let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(
            UICollectionElementKindSectionFooter,
            withReuseIdentifier: card.footerClass!.classReuseIdentifier,
            forIndexPath: indexPath
        ) as CardFooterCollectionReusableView
        
        animate(footerView, ofType: .Footer, atIndexPath: indexPath)
        if let delegate = cardFooterDelegate {
            footerView.cardFooterDelegate = delegate
        }
        
        footerView.card = card
        return footerView
    }
    
    private func animate(view: UICollectionReusableView, ofType typeOfView: TypeOfView, atIndexPath indexPath: NSIndexPath) {
        if !animateContent {
            return
        }
        
        var uniqueIndex: String
        
        // Unique indexes make sure each item or supplementary view animates only once
        switch typeOfView {
        case .Cell:
            uniqueIndex = String(indexPath.section) + String(indexPath.row)
            
        case .Footer:
            uniqueIndex = String((indexPath.section + 1) * 2000)
            
        case .Header:
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
        card.cardIndex = cards.count
        cards.append(card)
    }
    
    final func removeCard(card: Card) {
        if let index = find(cards, card) {
            cards.removeAtIndex(index)
        }
    }
    
    final func insertCard(card: Card, atIndex index: Int) {
        card.cardIndex = index
        cards.insert(card, atIndex: index)
    }

    final func removeCardAtIndex(index: Int) {
        cards.removeAtIndex(index)
    }
    
    final func resetCards() {
        cards.removeAll(keepCapacity: true)
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

    // MARK: - Footer Registration
    
    private func registerReusableFooter(collectionView: UICollectionView, forCard card: Card) {
        if card.addFooter {
            if !registeredFooterClasses.containsObject(card.footerClassName!) {
                collectionView.registerNib(
                    UINib(nibName: card.footerClassName!, bundle: nil),
                    forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                    withReuseIdentifier: card.footerClass!.classReuseIdentifier
                )
                
                registeredFooterClasses.addObject(card.footerClassName!)
            }
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
