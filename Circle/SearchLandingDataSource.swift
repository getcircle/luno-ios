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
    
    private var profilesAssociatedWithNotes = Array<Services.Profile.Containers.ProfileV1>()

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            Services.Feed.Actions.getProfileFeed(currentProfile.id) { (categories, error) -> Void in
                if error == nil {
                    self.resetCards()
                    
                    // Add quick actions to the top
                    let quickActionsCard = Card(cardType: .QuickActions, title: "Quick Actions", addDefaultFooter: false)
                    quickActionsCard.addContent(content: [["placeholder": true]], maxVisibleItems: 0)
                    quickActionsCard.sectionInset = UIEdgeInsetsMake(15.0, 10.0, 25.0, 10.0)
                    self.appendCard(quickActionsCard)

                    for category in categories ?? [] {
                        let categoryCard = Card(category: category)
                        categoryCard.addDefaultHeader()
                        if category.notes.count > 0 {
                            categoryCard.addContent(content: category.notes, maxVisibleItems: 5)
                            categoryCard.metaData = category.profiles
                            self.profilesAssociatedWithNotes = category.profiles
                        } else if category.profiles.count > 0 {
                            var profiles = category.profiles
                            var maxVisibleItems = 0
                            switch category.categoryType {
                            case .Birthdays, .Anniversaries, .NewHires:
                                // HACK: limit the number of results in a card to 3 until we can get smarter about displaying them on the detail view
                                maxVisibleItems = 3
                            default: break
                            }
                            categoryCard.addContent(content: profiles, maxVisibleItems: maxVisibleItems)
                        } else if category.addresses.count > 0 {
                            // don't display offices on the search landing page
                            continue
                        } else if category.tags.count > 0 {
                            categoryCard.addContent(content: category.tags, maxVisibleItems: 10)
                        }
                        self.appendCard(categoryCard)
                    }
                }
                completionHandler(error: error)
            }
        }
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
        
        if cell is NotesCollectionViewCell && profilesAssociatedWithNotes.count > 0 {
            (cell as! NotesCollectionViewCell).setProfile(profilesAssociatedWithNotes[indexPath.row])
        }
    }
}
