//
//  ProfileStatusDetailDataSource.swift
//  Luno
//
//  Created by Ravi Rani on 10/14/15.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileStatusDetailDataSource: CardDataSource {

    var profileStatus: Services.Profile.Containers.ProfileStatusV1!
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        Services.Profile.Actions.getStatus(profileStatus.id) { (status, error) -> Void in
            if let status = status {
                self.profileStatus = status
                self.addStatusCard()
            }
            completionHandler(error: error)
        }
    }
    
    override func getTitle() -> String {
        return profileStatus.profile.firstName + "'s " + AppStrings.ProfileStatusDetailNavTitle
    }
    
    private func addStatusCard() {
        
        // Placeholder
        let placeholderCard = Card(cardType: .Placeholder, title: "")
        placeholderCard.sectionInset = UIEdgeInsetsMake(30.0, 0.0, 0.0, 0.0)
        appendCard(placeholderCard)

        // Status Card
        let cardTitle = profileStatus.profile.firstName + "'s Status " + TextData.getFormattedTimestamp(profileStatus.changed, authorProfile: nil, addNewLine: false)!
        let card = Card(
            cardType: .TextValue,
            title: cardTitle
        )
        
        card.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
        card.showContentCount = false
        card.addContent(content: [
            TextData(
                type: TextData.TextDataType.ProfileStatus,
                andValue: profileStatus.value
            )
        ])
        card.sectionInset = UIEdgeInsetsMake(0.0, 10.0, 1.0, 10.0)
        appendCard(card)
        
        // Profile card
        let profileCard = Card(cardType: .Profiles, title: "")
        profileCard.addContent(content: [profileStatus.profile])
        appendCard(profileCard)
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        super.configureCell(cell, atIndexPath: indexPath)
        
        if let cell = cell as? TextValueCollectionViewCell {
            cell.textLabel.font = UIFont.italicFont(20.0)
        }
    }
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if let cardHeader = header as? ProfileSectionHeaderCollectionReusableView {
            cardHeader.addBottomBorder = true
        }
    }
}
