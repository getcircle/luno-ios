//
//  CurrentUserProfileDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 3/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class CurrentUserProfileDetailDataSource: ProfileDetailDataSource {

    var editImageButtonDelegate: EditImageButtonDelegate?
    
    override internal func addContactsCard() -> Card? {
        let card = Card(cardType: .KeyValue, title: "")
        card.sectionInset = sectionInsetWithLargerBootomMargin
        let contactData = KeyValueData(
            type: .ContactPreferences,
            title: AppStrings.ProfileSectionContactPreferencesTitle,
            value: ""
        )
        contactData.isTappable = true
        card.addContent(content: [contactData])
        appendCard(card)
        return card
    }
    
    override internal func addStatusCard() -> Card? {
        if let card = super.addStatusCard() {
            card.addHeader(headerClass: ProfileSectionHeaderCollectionReusableView.self)
            card.sectionInset = sectionInsetWithLargerBootomMargin
            card.allowEditingContent = true
            return card
        }
        
        return nil
    }
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if let profileHeader = header as? ProfileHeaderCollectionReusableView {
            profileHeader.setEditImageButtonHidden(false)
            profileHeader.editImageButtonDelegate = editImageButtonDelegate
        }
        
        if let headerView = header as? ProfileSectionHeaderCollectionReusableView, card = cardAtSection(indexPath.section) where card.allowEditingContent {
            headerView.showAddEditButton = true
        }
    }
}
