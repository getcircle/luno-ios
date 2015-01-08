//
//  ProfilesDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/5/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfilesDataSource: CardDataSource {

    private var profiles = Array<ProfileService.Containers.Profile>()
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Only try to load data if it doesn't exist
        if cards.count > 0 {
            return
        }

        // Append a Map Card for example
        var mapCard = Card(cardType: .Map, title: "Map")
        mapCard.content.append(["dummy_content": "dummy_content"])
        mapCard.sectionInset = UIEdgeInsetsZero
        appendCard(mapCard)
        
        if let currentProfile = AuthViewController.getLoggedInUserProfile() {
            let request = ProfileService.Requests.GetProfiles(currentProfile.team_id)
            let client = ServiceClient(serviceName: "profile")
            client.callAction(request) {
                (_, _, _, actionResponse, error) -> Void in
                if let actionResponse = actionResponse {
                    let response = ProfileService.Responses.GetProfiles(actionResponse)
                    if error != nil || !response.success {
                        println("error fetching profiles")
                        return
                    }

                    let result = response.result as ProfileService.GetProfiles.Response
                    self.profiles.extend(result.profiles)
                    let peopleCard = Card(cardType: .People, title: "Direct Reports")
                    peopleCard.content.extend(result.profiles as [AnyObject])
                    self.appendCard(peopleCard)
                    completionHandler(error: nil)
                }
            }
        }
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let profileCell = cell as? ProfileCollectionViewCell {
            profileCell.sizeMode = .Medium
            profileCell.subTextLabel.text = profiles[indexPath.row].title
        }
    }
}
