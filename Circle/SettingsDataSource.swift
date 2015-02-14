//
//  SettingsDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 2/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class SettingsDataSource: CardDataSource {

    enum SettingsCellType: Int {
        case AccountEmail
        case ContactEmail
        case ContactPhone
        case LegalAttributions
        case LegalPrivacy
        case LegalTermsOfService
        case LogOut
        case Other
        case Version
    }
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        
        // Security card
        var securityCard = Card(
            cardType: .Settings,
            title: NSLocalizedString("Security", comment: "Title of section related to security settings"),
            addDefaultFooter: false
        )
        securityCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)
        securityCard.addContent(content: [
            [
                "text": NSLocalizedString("Set a passcode", comment: "Title of button used to set a passcode"),
                "type": SettingsCellType.ContactEmail.rawValue
            ],
            [
                "text": NSLocalizedString("Enable Touch ID", comment: "Title of button to enable Touch ID"),
                "type": SettingsCellType.ContactPhone.rawValue
            ]
        ])
        appendCard(securityCard)

        // Contact card
        var contactCard = Card(
            cardType: .Settings,
            title: NSLocalizedString("Contact", comment: "Title of contact us section"),
            addDefaultFooter: false
        )
        contactCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)
        contactCard.addContent(content: [
            [
                "text": NSLocalizedString("Email us feedback", comment: "Title of button used to email app feedback"),
                "type": SettingsCellType.ContactEmail.rawValue
            ],
            [
                "text": NSLocalizedString("Call us", comment: "Title of button to call us"),
                "type": SettingsCellType.ContactPhone.rawValue
            ]
        ])
        appendCard(contactCard)

        // Legal card
        var legalCard = Card(
            cardType: .Settings,
            title: NSLocalizedString("Legal", comment: "Title of legal section"),
            addDefaultFooter: false
        )
        legalCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)
        legalCard.addContent(content: [
            [
                "text": NSLocalizedString("Attributions", comment: "Title of button to see third party library attributions"),
                "type": SettingsCellType.LegalAttributions.rawValue
            ],
            [
                "text": NSLocalizedString("Privacy Policy", comment: "Title of button to see the privacy policy"),
                "type": SettingsCellType.LegalPrivacy.rawValue
            ],
            [
                "text": NSLocalizedString("Terms of Service", comment: "Title of button to see the terms of service"),
                "type": SettingsCellType.LegalTermsOfService.rawValue
            ],
        ])
        appendCard(legalCard)

        // Account card
        var accountCard = Card(
            cardType: .KeyValue,
            title: "Account",
            addDefaultFooter: false
        )
        accountCard.sectionInset = UIEdgeInsetsZero
        accountCard.addContent(content: [
            [
                "name": NSLocalizedString("Email", comment: "Key for email section"),
                "value": AuthViewController.getLoggedInUser()!.primary_email,
                "type": SettingsCellType.AccountEmail.rawValue
            ]
        ])
        appendCard(accountCard)

        // Logout card
        var logoutCard = Card(
            cardType: .Settings, 
            title: "",
            addDefaultFooter: false
        )
        logoutCard.sectionInset = UIEdgeInsetsMake(1.0, 0.0, 10.0, 0.0)
        logoutCard.addContent(content: [
            [
                "text": NSLocalizedString("Sign out", comment: "Title of sign out button"),
                "type": SettingsCellType.LogOut.rawValue
            ]
        ])
        appendCard(logoutCard)
        
        // Version card
        var versionCard = Card(cardType: .Settings, title: "", addDefaultFooter: false)
        versionCard.sectionInset = UIEdgeInsetsZero
        versionCard.addContent(content: [
            [
                "text": NSString(format:
                    NSLocalizedString("Version %@", comment: "Version of the app"),
                    NSString(format: "%@ (%@)", NSBundle.appVersion(), NSBundle.appBuild())
                ),
                "type": SettingsCellType.Version.rawValue
            ]
        ])
        appendCard(versionCard)
        completionHandler(error: nil)
    }
    
    func typeOfCell(indexPath: NSIndexPath) -> SettingsCellType {
        let card = cards[indexPath.section]
        if let rowDataDictionary = card.content[indexPath.row] as? [String: AnyObject] {
            return SettingsCellType(rawValue: (rowDataDictionary["type"] as Int!))!
        }
        
        return .Other
    }
    
    // MARK: - Cell configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let settingsCell = cell as? SettingsCollectionViewCell {
            
            let cellType = typeOfCell(indexPath)
            var backgroundColor = UIColor.whiteColor()
            var backgroundView = settingsCell.defaultSelectionBackgroundView
            var font = UIFont(name: settingsCell.itemLabel.font.familyName, size: settingsCell.initialFontSize)
            var hideNextIcon = true
            var textAlignment: NSTextAlignment = .Left
            
            switch cellType {
            case .Version:
                backgroundColor = UIColor.clearColor()
                textAlignment = .Center
                font = UIFont(
                    name: settingsCell.itemLabel.font.familyName,
                    size: 14.0
                )
                backgroundView = nil
            
            case .LogOut:
                textAlignment = .Center
                
            case .LegalAttributions, .LegalPrivacy, .LegalTermsOfService:
                hideNextIcon = false
                
            default:
                break
            }
            
            cell.backgroundColor = backgroundColor
            settingsCell.itemLabel.textAlignment = textAlignment
            settingsCell.itemLabel.font = font
            settingsCell.selectedBackgroundView = backgroundView
            settingsCell.pushesNewViewImage.hidden = hideNextIcon
        }
        else {
            // Currently no cell except settings cells should be active
            cell.selectedBackgroundView = nil
        }
    }
    
    // MARK: - Section header
    
    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "SearchResultsCardHeaderCollectionReusableView", bundle: nil), 
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, 
            withReuseIdentifier: SearchResultsCardHeaderCollectionReusableView.classReuseIdentifier
        )
        
        super.registerCardHeader(collectionView)
    }
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: SearchResultsCardHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
        ) as SearchResultsCardHeaderCollectionReusableView
        
        headerView.setCard(cards[indexPath.section])
        headerView.cardTitleLabel.font = UIFont.appSettingsCardHeader()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
}
