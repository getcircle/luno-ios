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
    
    // MARK: - Set Initial Data
    
    override func setInitialData(content: [AnyObject]) {
        let profilesCard = Card(cardType: .People, title: "")
        profilesCard.content.extend(content)
        appendCard(profilesCard)
    }
    
    // MARK: - Load Data
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        completionHandler(error: nil)
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let profileCell = cell as? ProfileCollectionViewCell {
            profileCell.sizeMode = .Medium
            let profile = contentAtIndexPath(indexPath) as? ProfileService.Containers.Profile
            profileCell.subTextLabel.text = profile?.title
        }
    }
}
