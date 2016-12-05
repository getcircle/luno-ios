//
//  PostsOverviewDataSource.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-20.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class PostsOverviewDataSource: CardDataSource {

    var searchLocation: TrackerProperty.SearchLocation!
    
    private var card: Card!
    internal var cardType: Card.CardType = .Profiles
    private(set) var searchAttribute: Services.Search.Containers.Search.AttributeV1?
    private(set) var searchTrackerAttribute: TrackerProperty.SearchAttribute?
    private(set) var searchAttributeValue: String?
    private var searchStartTracked = false
    private var posts = Array<Services.Post.Containers.PostV1>()
    
    override class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 60.0, 0.0, 20.0)
    }
    
    // MARK: - Configuration
    
    func configureForOrganization() throws {
        let requestBuilder = Services.Post.Actions.GetPosts.RequestV1.Builder()
        requestBuilder.state = .Listed
        try configureForParameters(requestBuilder)
    }
    
    private func configureForParameters(requestBuilder: AbstractMessageBuilder) throws {
        let client = ServiceClient(serviceName: "post")
        let serviceRequest = try client.buildRequest(
            "get_posts",
            extensionField: Services.Registry.Requests.Post.getPosts(),
            requestBuilder: requestBuilder,
            paginatorBuilder: nil
        )
        if nextRequest == nil {
            registerNextRequest(nextRequest: serviceRequest)
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.showSeparator = !cellAtIndexPathIsBottomOfSection(indexPath)
    }
    
    // MARK: - Set Initial Data
    
    override func setInitialData(content: [AnyObject], ofType: Card.CardType?) {
        posts.appendContentsOf(content as! [Services.Post.Containers.PostV1])
        if ofType != nil {
            cardType = ofType!
        }
    }
    
    override func setInitialData(content content: [AnyObject], ofType: Card.CardType?, nextRequest withNextRequest: Soa.ServiceRequestV1?) {
        registerNextRequest(nextRequest: withNextRequest)
        setInitialData(content, ofType: ofType)
    }
    
    // MARK: - Load Data
    
    override func loadInitialData(completionHandler: (error: NSError?) -> Void) {
        super.loadInitialData(completionHandler)
        
        let sectionInset = UIEdgeInsetsZero
        
        card = Card(cardType: cardType, title: "")
        card.sectionInset = sectionInset
        
        registerNextRequestCompletionHandler { (_, _, wrapped, error) -> Void in
            let response = wrapped?.response?.result.getExtension(
                Services.Registry.Requests.Post.getPosts()
                ) as? Services.Post.Actions.GetPosts.ResponseV1
            
            if let posts = response?.posts {
                self.posts.appendContentsOf(posts)
                self.card.addContent(content: posts)
                self.handleNewContentAddedToCard(self.card, newContent: posts)
            }
        }
        
        appendCard(card)
        card.addContent(content: posts)
        if posts.count > 0 {
            completionHandler(error: nil)
        }
        else {
            if canTriggerNextRequest() {
                triggerNextRequest { () -> Void in
                    completionHandler(error: nil)
                }
            }
        }
    }
    
    // MARK: - Filtering
    
    override func handleFiltering(query: String, completionHandler: (error: NSError?) -> Void) {
        if query.characters.count < 2 {
            searchStartTracked = false
        }
        else if query.characters.count >= 2 && !searchStartTracked {
            searchStartTracked = true
            Tracker.sharedInstance.trackSearchStart(
                query: query,
                searchLocation: searchLocation,
                category: .Posts,
                attribute: searchTrackerAttribute,
                value: searchAttributeValue
            )
        }
        
        Services.Search.Actions.search(
            query,
            category: .Posts,
            attribute: searchAttribute,
            attributeValue: searchAttributeValue,
            completionHandler: { (query, results, error) -> Void in
                
                var resultPosts = Array<Services.Post.Containers.PostV1>()
                if let results = results {
                    for result in results {
                        if let post = result.post {
                            resultPosts.append(post)
                        }
                    }
                }
                
                self.card.resetContent(resultPosts)
                completionHandler(error: error)
                return
            }
        )
    }
    
    override func clearFilter(completionHandler: () -> Void) {
        super.clearFilter(completionHandler)
        card.resetContent(posts)
        completionHandler()
    }
    
}
