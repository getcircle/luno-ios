//
//  SearchLandingDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/3/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

class SearchLandingDataSource: CardDataSource {

    private var notesCard: Card?

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        if cards.count > 0 {
            loadNotes(completionHandler)
            completionHandler(error: nil)
            return
        }
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            LandingService.Actions.getCategories(currentProfile.id) { (categories, error) -> Void in
                if error == nil {
                    for category in categories ?? [] {
                        let categoryCard = Card(category: category)
                        if category.profiles.count > 0 {
                            var profiles = category.profiles
                            var maxVisibleItems = 0
                            switch category.type {
                            case .Birthdays, .Anniversaries, .NewHires:
                                // HACK: limit the number of results in a card to 3 until we can get smarter about displaying them on the detail view
                                maxVisibleItems = 3
                            default: break
                            }
                            categoryCard.addContent(content: profiles, maxVisibleItems: maxVisibleItems)
                        } else if category.addresses.count > 0 {
                            // don't display locations on the search landing page
                            continue
                        } else if category.tags.count > 0 {
                            categoryCard.addContent(content: category.tags, maxVisibleItems: 10)
                        }
                        self.appendCard(categoryCard)
                    }
                    completionHandler(error: nil)
                }
            }
            
            loadNotes(completionHandler)
        }
    }

    private func loadNotes(completionHandler: (error: NSError?) -> Void) {
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            NoteService.Actions.getNotes(currentProfile.id) { (notes, error) -> Void in
                if let notes = notes {
                    if self.notesCard == nil {
                        self.notesCard = Card(cardType: .Notes, title: "Notes", addDefaultFooter: false)
                        self.insertCard(self.notesCard!, atIndex: 0)
                    }
                    else {
                        self.notesCard!.resetContent()
                    }
                    
                    self.notesCard!.addContent(content: notes, maxVisibleItems: 3)
                    self.notesCard!.contentCount = notes.count

                    completionHandler(error: error)
                }
            }
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
    }

}
