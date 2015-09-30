//
//  SettingsDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 2/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SettingsDataSource: CardDataSource {

    enum SettingsCellType: Int {
        case AccountEmail
        case ContactEmail
        case ContactPhone
        case Disconnect
        case GoogleDisconnect
        case LegalAttributions
        case LegalPrivacy
        case LegalTermsOfService
        case LogOut
        case SecurityPasscodeAndTouchID
        case Other
        case Version
    }
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        
        let sectionHeaderClass = SettingsSectionHeaderCollectionReusableView.self
        let sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)

        // Security card
        let securityCard = Card(
            cardType: .Settings,
            title: NSLocalizedString("Security", comment: "Title of section related to security settings")
        )
        securityCard.addHeader(headerClass: sectionHeaderClass)
        securityCard.sectionInset = sectionInset
        securityCard.showContentCount = false
        securityCard.addContent(content: [
            [
                "text": NSLocalizedString("Passcode & Touch ID", comment: "Title of button used to set a passcode and enable Touch ID"),
                "type": SettingsCellType.SecurityPasscodeAndTouchID.rawValue
            ],
        ])
        appendCard(securityCard)

        // Contact card
        let contactCard = Card(
            cardType: .Settings,
            title: NSLocalizedString("Contact", comment: "Title of contact us section")
        )
        contactCard.addHeader(headerClass: sectionHeaderClass)
        contactCard.sectionInset = sectionInset
        contactCard.showContentCount = false
        contactCard.addContent(content: [
            [
                "text": NSLocalizedString("Email us feedback", comment: "Title of button used to email app feedback"),
                "type": SettingsCellType.ContactEmail.rawValue
            ],
//            [
//                "text": NSLocalizedString("Call us", comment: "Title of button to call us"),
//                "type": SettingsCellType.ContactPhone.rawValue
//            ]
        ])
        appendCard(contactCard)

        // Legal card
        let legalCard = Card(
            cardType: .Settings,
            title: NSLocalizedString("Legal", comment: "Title of legal section")
        )
        legalCard.addHeader(headerClass: sectionHeaderClass)
        legalCard.sectionInset = sectionInset
        legalCard.showContentCount = false
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
        let logoutCard = Card(
            cardType: .Settings, 
            title: "Account"
        )
        logoutCard.addHeader(headerClass: sectionHeaderClass)
        logoutCard.sectionInset = sectionInset
        logoutCard.showContentCount = false
        let accountContent = [[
            "text": AuthenticationViewController.getLoggedInUser()!.primaryEmail,
            "type": SettingsCellType.AccountEmail.rawValue
        ],
        [
            "text": AppStrings.SignOutButtonTitle,
            "type": SettingsCellType.LogOut.rawValue
        ]]
        
//        if let identities = AuthenticationViewController.getLoggedInUserIdentities() where identities.count > 0 {
//            for identity in identities {
//                if identity.provider == .Google {
//                    accountContent.append([
//                        "text": AppStrings.SignOutDisconnectButtonTitle,
//                        "type": SettingsCellType.Disconnect.rawValue
//                    ])
//                    break
//                }
//            }
//        }

        logoutCard.addContent(content: accountContent)
        appendCard(logoutCard)
        
        // Version card
        let versionCard = Card(cardType: .Settings, title: "")
        versionCard.addHeader(headerClass: sectionHeaderClass)
        versionCard.sectionInset = sectionInset
        versionCard.showContentCount = false
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
            return SettingsCellType(rawValue: (rowDataDictionary["type"] as! Int!))!
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
            
            case .Disconnect, .LogOut:
                textAlignment = .Center
            
            case .SecurityPasscodeAndTouchID:
                hideNextIcon = false

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
}
