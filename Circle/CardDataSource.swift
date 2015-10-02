//
//  CardDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
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
    case CellPhone
    case ContactPreferences
    case EditTeam
    case Email
    case Facebook
    case HireDate
    case Locations
    case Other
    case Twitter
    case WorkPhone
}

enum CardDataSourceState {
    case Loaded
    case Loading
    case Filtered
    case AllLoaded
}

@objc protocol CardDataSourceDelegate {
    // TODO we should combine these into like onStateChanged when @objc protocol can accept swift arguments
    optional func onDataLoading()
    optional func onDataLoaded(indexPaths: [NSIndexPath])
    optional func onAllDataLoaded()
}

class CardDataSource: NSObject, UICollectionViewDataSource {
    
    enum TypeOfView {
        case Cell
        case Footer
        case Header
    }
    
    internal(set) var state: CardDataSourceState = .Loaded
    private(set) var nextRequest: Soa.ServiceRequestV1?
    private(set) var nextRequestCompletionHandler: ServiceCompletionHandler?
    private var hasLoadedOnce = false
    var contentThreshold: Float = 50.0
    var delegate: CardDataSourceDelegate?

    class var cardSeparatorColor: UIColor {
        return UIColor.appCardContentSeparatorViewColor()
    }
    class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsZero
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
    private var registeredCellClasses = NSMutableSet()
    
    var cardHeaderDelegate: CardHeaderViewDelegate?
    private var registeredHeaderClasses = NSMutableSet()

    /**
    Footer view delegate.
    */
    var cardFooterDelegate: CardFooterViewDelegate?
    private var registeredFooterClasses = NSMutableSet()

    /**
    This method should be called when the view controller is ready to request for data. This is typically
    in viewWillAppear. The data source class is closely tied to the collection view, so it refreshes
    the collection view on its own once it has the available data.

    Each subclass must override this method. The default implementation does not do anything and it is not
    expected to be called from the subclasses.
    
    - parameter completionHandler: Closure called when the data or status is available.
    */
    func loadData(completionHandler: (error: NSError?) -> Void) {
        if !hasLoadedOnce {
            loadInitialData(completionHandler)
        } else {
            refreshData(completionHandler)
        }
    }
    
    func setInitialData(content: [AnyObject], ofType: Card.CardType? = .Profiles) {
        fatalError("All subclasses need to override this")
    }
        
    func setInitialData(content content: [AnyObject], ofType: Card.CardType? = .Profiles, nextRequest withNextRequest: Soa.ServiceRequestV1?) {
        fatalError("All subclasses need to override this")
    }
    
    func loadInitialData(completionHandler: (error: NSError?) -> Void) {
        hasLoadedOnce = true
    }
    
    func refreshData(completionHandler: (error: NSError?) -> Void) {
        
    }
    
    func canEdit() -> Bool {
        return false
    }
    
    /**
    Configure cell instances for display. The default implementation of this method is empty.
    
    This method is called from cellForItemAtIndexPath and from sizeForItemAtIndexPath if the size calculation
    method is Dynamic. This is to make sure prototype cells and real cells are configured exactly the same.

    Subclasses can override this method to further customize cells per instance. The customization should
    be minimum and generally not include fixed layout changes. A good use case of cell configuration would be 
    to hide/show a label within a cell depending on the use case.
    
    - parameter cell: Cell being configured.
    - parameter indexPath: Indexpath of the cell.
    */
    func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        // Default Implementation
    }
    
    func cellAtIndexPathIsBottomOfSection(indexPath: NSIndexPath) -> Bool {
        let card = cards[indexPath.section]
        let isLastCell = (indexPath.row == card.content.count - 1)
        let isLastViewInSection = (isLastCell && !card.addFooter)
        
        return isLastViewInSection
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
        if shouldTriggerNextRequest(card, indexPath: indexPath) {
            triggerNextRequest(nil)
        }
        
        registerReusableCell(collectionView, forCard: card)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            card.contentClass.classReuseIdentifier,
            forIndexPath: indexPath
        ) as! CircleCollectionViewCell
        
        cell.card = card
        cell.setData(card.content[indexPath.row])
        cell.separatorColor = self.dynamicType.cardSeparatorColor
        cell.separatorInset = self.dynamicType.cardSeparatorInset
        configureCell(cell, atIndexPath: indexPath)
        animate(cell, ofType: .Cell, atIndexPath: indexPath)
        return cell
    }
    
    /**
        Configure header instances for display. The default implementation of this method is empty.
        
        This method is called from viewForSupplementaryElementOfKind.
        
        Subclasses can override this method to further customize headers per instance and to provide custom data. 
        The customization should be minimum and generally not include fixed layout changes. A good use case of header 
        configuration would be to hide/show a label within a header depending on the use case.
        
        - parameter header: Header being configured.
        - parameter indexPath: Indexpath of the header.
    */
    func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        // Default Implementation
    }
    
    final func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let card = cards[indexPath.section]

        if kind == UICollectionElementKindSectionFooter && card.addFooter {
            return addFooterView(collectionView, atIndexPath: indexPath)
        }
        else if kind == UICollectionElementKindSectionHeader && card.addHeader {
            return addHeaderView(collectionView, atIndexPath: indexPath)
        }
        
        // We should never get here
        assert(false, "Headers not configured correctly. Check addHeader calls on cards.")
        return CircleCollectionReusableView()
    }
    
    /**
    Configure footer instances for display. The default implementation of this method is empty.
    
    This method is called from viewForSupplementaryElementOfKind.
    
    Subclasses can override this method to further customize footers per instance and to provide custom data.
    The customization should be minimum and generally not include fixed layout changes. A good use case of footer
    configuration would be to hide/show a label within a footer depending on the use case.
    
    - parameter footer: Footer being configured.
    - parameter indexPath: Indexpath of the footer.
    */
    func configureFooter(footer: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        // Default Implementation
    }
    
    private func addHeaderView(collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let card = cards[indexPath.section]
        registerReusableHeader(collectionView, forCard: card)
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
            UICollectionElementKindSectionHeader,
            withReuseIdentifier: card.headerClass!.classReuseIdentifier,
            forIndexPath: indexPath
        ) as! CircleCollectionReusableView
        
        if let delegate = cardHeaderDelegate {
            headerView.cardHeaderDelegate = delegate
        }

        configureHeader(headerView, atIndexPath: indexPath)
        headerView.setCard(card)
        animate(headerView, ofType: .Header, atIndexPath: indexPath)
        return headerView
    }

    private func addFooterView(collectionView: UICollectionView, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let card = cards[indexPath.section]
        registerReusableFooter(collectionView, forCard: card)
        let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(
            UICollectionElementKindSectionFooter,
            withReuseIdentifier: card.footerClass!.classReuseIdentifier,
            forIndexPath: indexPath
        ) as! CardFooterCollectionReusableView
        
        if let delegate = cardFooterDelegate {
            footerView.cardFooterDelegate = delegate
        }
        
        footerView.card = card
        configureFooter(footerView, atIndexPath: indexPath)
        animate(footerView, ofType: .Footer, atIndexPath: indexPath)
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
        
        let intIndex = Int(uniqueIndex) ?? 0
        if animatedRowIndexes.containsIndex(intIndex) == false {
            animatedRowIndexes.addIndex(intIndex)
            let finalFrame = view.frame
            view.frame.origin.y = finalFrame.origin.y + 40.0
            
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
        if let index = cards.indexOf(card) {
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
    
    // MARK: - Header Registration
    
    private func registerReusableHeader(collectionView: UICollectionView, forCard card: Card) {
        if card.addHeader {
            if !registeredHeaderClasses.containsObject(card.headerClassName!) {
                collectionView.registerNib(
                    UINib(nibName: card.headerClassName!, bundle: nil),
                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                    withReuseIdentifier: card.headerClass!.classReuseIdentifier
                )
                
                registeredHeaderClasses.addObject(card.headerClassName!)
            }
        }
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
    
        - parameter section: Section index.
    
        - returns: Card object or nil.
    */
    func cardAtSection(section: Int) -> Card? {
        return cards[section] ?? nil
    }
    
    func sectionForCard(card withCard: Card) -> Int? {
        var section: Int?
        for (cardIndex, card) in cards.enumerate() {
            if card == withCard {
                section = cardIndex
                break
            }
        }
        return section
    }
    
    /**
        Return the content object at a particular indexPath.
        
        - parameter indexPath: NSIndexPath.
        
        - returns: AnyObject content object or nil.
    */
    func contentAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        if let card = cards[indexPath.section] as Card? {
            if let content: AnyObject = card.content[indexPath.row] as AnyObject? {
                return content
            }
        }

        return nil
    }
    
    // MARK: - Pagination
    
    func registerNextRequest(nextRequest withNextRequest: Soa.ServiceRequestV1?) {
        nextRequest = withNextRequest
    }
    
    func registerNextRequest(nextRequest withNextRequest: Soa.ServiceRequestV1, completionHandler: ServiceCompletionHandler) {
        nextRequest = withNextRequest
        nextRequestCompletionHandler = completionHandler
    }
    
    func registerNextRequestCompletionHandler(completionHandler: ServiceCompletionHandler) {
        nextRequestCompletionHandler = completionHandler
    }
    
    func handleNewContentAddedToCard(card: Card, newContent: [AnyObject]) {
        if let section = sectionForCard(card: card) {
            var indexPaths = [NSIndexPath]()
            for var i = card.content.count - newContent.count; i < card.content.count; i++ {
                indexPaths.append(NSIndexPath(forRow: i, inSection: section))
            }
            delegate?.onDataLoaded?(indexPaths)
        }
    }
    
    func canTriggerNextRequest() -> Bool {
        switch state {
        case .Loading, .Filtered: return false
        default: break
        }

        return nextRequest != nil && nextRequestCompletionHandler != nil
    }
    
    private func shouldTriggerNextRequest(card: Card, indexPath: NSIndexPath) -> Bool {
        if !canTriggerNextRequest() {
            return false
        }
        
        // Avoid dividing by 0
        var currentRow = indexPath.row
        if currentRow == 0 {
            currentRow = 1
        }
        
        let percentContent = Float(currentRow) / Float(card.content.count) * 100
        if percentContent >= contentThreshold {
            return true
        }
        return false
    }
    
    func triggerNextRequest(completionHandler: (() -> Void)?) {
        if let request = nextRequest {
            if let requestCompletionHandler = nextRequestCompletionHandler {
                state = .Loading
                self.delegate?.onDataLoading?()
                ServiceClient.sendRequest(request) { (request, response, wrapped, error) -> Void in
                    self.nextRequest = nil
                    self.state = .AllLoaded
                    if let paginator = wrapped?.getPaginator() {
                        if paginator.hasNextPage {
                            self.nextRequest = wrapped?.getNextRequest()
                            self.state = .Loaded
                        }
                    }
                    requestCompletionHandler(request, response, wrapped, error)
                    completionHandler?()
                }
            } else {
                completionHandler?()
            }
        }
    }
    
    // MARK: - Filtering
    
    func filter(query: String, completionHandler: (error: NSError?) -> Void) {
        state = .Filtered
        handleFiltering(query) { (error: NSError?) -> Void in
            completionHandler(error: error)
        }
    }
    
    func handleFiltering(query: String, completionHandler: (error: NSError?) -> Void) {
        fatalError("subclasses must override this method")
    }
    
    func clearFilter(completionHandler: () -> Void) {
        state = .Loaded
    }

}
