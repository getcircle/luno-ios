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
        if let card = super.addContactsCard() {
            card.allowEditingContent = true
            return card
        }
        
        return nil
    }
    
    override internal func addStatusCard() -> Card? {
        if let card = super.addStatusCard() {
            card.allowEditingContent = true
            
            // Add a different placeholder when current user is looking at it
            if let textData = card.content.first as? TextData {
                textData.placeholder = NSLocalizedString("Add details", comment: "Generic text asking user to add details")
                card.resetContent()
                card.addContent(content: [textData])
            }
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
