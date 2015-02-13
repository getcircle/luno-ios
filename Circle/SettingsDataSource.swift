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
        case LogOut
        case Version
        case Other
    }
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {

        // Account card
        var logoutCard = Card(cardType: .Settings, title: "Account", addDefaultFooter: false)
        logoutCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)
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
        let settingsCell = (cell as SettingsCollectionViewCell)
        if typeOfCell(indexPath) == .Version {
            cell.backgroundColor = UIColor.clearColor()
            settingsCell.itemLabel.textAlignment = .Center
            settingsCell.itemLabel.font = UIFont(
                name: settingsCell.itemLabel.font.familyName,
                size: 14.0
            )
            settingsCell.selectedBackgroundView = nil
        }
        else {
            cell.backgroundColor = UIColor.whiteColor()
            settingsCell.itemLabel.textAlignment = .Left
            settingsCell.itemLabel.font = UIFont(
                name: settingsCell.itemLabel.font.familyName, 
                size: settingsCell.initialFontSize
            )
            settingsCell.selectedBackgroundView = settingsCell.defaultSelectionBackgroundView
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
