//
//  ProfileDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ItemImage {
    var name: String
    var tint: UIColor
    
    init(name itemName: String, tint itemTint: UIColor) {
        name = itemName
        tint = itemTint
    }
}

class SectionItem {
    var title: String
    var image: ItemImage?
    var container: String
    var containerKey: String
    
    init(
        title itemTitle: String,
        container itemContainer: String,
        containerKey itemContainerKey: String,
        image itemImage: ItemImage?
    ) {
        title = itemTitle
        container = itemContainer
        containerKey = itemContainerKey
        image = itemImage
    }
}

class Section {
    var title: String
    var items: [SectionItem]
    var cardType: Card.CardType
    
    init(title sectionTitle: String, items sectionItems: [SectionItem], cardType sectionCardType: Card.CardType) {
        title = sectionTitle
        items = sectionItems
        cardType = sectionCardType
    }
}

class ProfileDetailDataSource: CardDataSource {

    enum CellType: String {
        case Email = "email"
        case CellPhone = "cell"
        case Twitter = "twitter"
        case Facebook = "facebook"
        case LinkedIn = "linkedin"
        case Github = "github"
        case Manager = "manager"
        case Other = "other"
        
        static let allValues = [Email, CellPhone, Twitter, Facebook, LinkedIn, Github, Manager]
        static func typeByKey(key: String) -> CellType {
            for value in self.allValues {
                if value.rawValue == key {
                    return value
                }
            }
            
            return .Other
        }
    }

    var manager: ProfileService.Containers.Profile?
    var profile: ProfileService.Containers.Profile!
    
    private var address: OrganizationService.Containers.Address?
    private var tags: Array<ProfileService.Containers.Tag>?
    private var team: OrganizationService.Containers.Team?

    private(set) var profileHeaderView: ProfileHeaderCollectionReusableView?
    private var sections = [Section]()
    
    // TODO convert to SectionItem
//    let socialInfoKeySet = [
//        "twitter",
//        "facebook",
//        "pinterest",
//        "linkedin",
//        "github",
//        "gplus"
//    ]
    
//    let keyToTitle = [
//        "email": "Email",
//        "cell_phone": "Cell Phone",
//        "location": "City",
//        "country": "Country",
//        "manager": "Manager",
//        "department": "Department",
//        "twitter": "Twitter",
//        "facebook": "Facebook",
//        "pinterest": "Pinterest",
//        "linkedin": "LinkedIn",
//        "github": "Github",
//        "gplus": "Google+"
//    ]
    
//    let keyToImageDictionary: [String: [String: AnyObject]] = [
//        "twitter": [
//            "image": "Twitter",
//            "tintColor": UIColor.twitterColor(),
//        ],
//        "facebook": [
//            "image": "Facebook",
//            "tintColor": UIColor.facebookColor(),
//        ],
//        "pinterest": [
//            "image": "Pinterest",
//            "tintColor": UIColor.pinterestColor(),
//        ],
//        "linkedin": [
//            "image": "LinkedIn",
//            "tintColor": UIColor.linkedinColor(),
//        ],
//        "github": [
//            "image": "Github",
//            "tintColor": UIColor.githubColor(),
//        ],
//        "gplus": [
//            "image": "GooglePlus",
//            "tintColor": UIColor.googlePlusColor(),
//        ],
//        "email": [
//            "image": "EmailCircle",
//            "tintColor": UIColor.emailTintColor(),
//        ],
//        "cell": [
//            "image": "Telephone",
//            "tintColor": UIColor.phoneTintColor(),
//        ],
//    ]

    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerNib(
            UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier
        )
        
        // TODO should have some like "onLoad" function we can plug into
        configureSections()
        super.registerCardHeader(collectionView)
    }

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Add placeholder card to load profile header instantly
        var placeholderCard = Card(cardType: .Placeholder, title: "Info")
        appendCard(placeholderCard)
        ProfileService.Actions.getExtendedProfile(profile.id) {
            (profile, manager, team, address, tags, error) -> Void in
            if error == nil {
                self.manager = manager
                self.team = team
                self.address = address
                self.tags = tags
                self.populateData()
            }
            completionHandler(error: error)
        }
    }
    
    // MARK: - Configuration
    
    private func configureSections() {
        sections.append(getBasicInfoSection())
        sections.append(getManagerInfoSection())
        sections.append(getTagsSection())
    }
    
    private func getBasicInfoSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "Email",
                container: "profile",
                containerKey: "email",
                image: ItemImage(name: "EmailCircle", tint: UIColor.emailTintColor())
            ),
            SectionItem(
                title: "Cell Phone",
                container: "profile",
                containerKey: "cell_phone",
                image: ItemImage(name: "Telephone", tint: UIColor.phoneTintColor())
            ),
            SectionItem(
                title: "City",
                container: "address",
                containerKey: "city",
                image: nil
            ),
            SectionItem(
                title: "Country",
                container: "address",
                containerKey: "country_code",
                image: nil
            )
        ]
        return Section(title: "Info", items: sectionItems, cardType: .KeyValue)
    }
    
    private func getManagerInfoSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "Manager",
                container: "manager",
                containerKey: "full_name",
                image: nil
            ),
            SectionItem(
                title: "Team",
                container: "team",
                containerKey: "name",
                image: nil
            )
            //            SectionItem(
            //                title: "Department",
            //                container: "team",
            //                containerKey: "department",
            //                image: nil
            //            )
        ]
        return Section(title: "Manager Info", items: sectionItems, cardType: .KeyValue)
    }
    
    private func getTagsSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "Tags",
                container: "tags",
                containerKey: "name",
                image: nil
            )
        ]
        return Section(title: "Tags", items: sectionItems, cardType: .Tags)
    }
    
    // MARK: - Populate Data
    
    private func populateData() {
        resetCards()
        
        var defaultSectionInset = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
        for section in sections {
            let sectionCard = Card(cardType: section.cardType, title: section.title)
            for item in section.items {
                addItemToCard(item, card: sectionCard)
            }
            
            sectionCard.sectionInset = defaultSectionInset
            if sectionCard.content.count > 0 {
                appendCard(sectionCard)
            }
        }
        
        // Add Notes Card
        var notesCard = Card(cardType: .Notes, title: "Notes")
        notesCard.content.append(["text": "This is a long sample note which should be at least two lines. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."])
        notesCard.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 55.0, 0.0)
        appendCard(notesCard)
    }
    
    private func addItemToCard(item: SectionItem, card: Card) {
        switch card.type {
        case .KeyValue: addKeyValueItemToCard(item, card: card)
        case .Tags: addTagsItemToCard(item, card: card)
        default: break
        }
    }
    
    private func addKeyValueItemToCard(item: SectionItem, card: Card) {
        var value: AnyObject?
        switch item.container {
        case "profile":
            value = profile[item.containerKey]
        case "manager":
            value = manager?[item.containerKey]
        case "address":
            value = address?[item.containerKey]
        case "team":
            value = team?[item.containerKey]
        default:
            value = nil
        }
        
        if let value: AnyObject = value {
            var dataDict: [String: AnyObject!] = [
                "key": item.containerKey,
                "name": item.title,
                "value": value
            ]
            
            if let image = item.image {
                dataDict["image"] = image.name
                dataDict["imageTintColor"] = image.tint
            }
            
            card.content.append(dataDict)
        }
    }
    
    private func addTagsItemToCard(item: SectionItem, card: Card) {
        if let tags = tags {
            card.content.append(tags as [AnyObject])
        }
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is TagsCollectionViewCell {
            (cell as TagsCollectionViewCell).showTagsLabel = true
        }
    }
    
    // MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as ProfileHeaderCollectionReusableView
            
            if profile != nil {
                supplementaryView.setProfile(profile)
            }
            profileHeaderView = supplementaryView
            return supplementaryView
    }
    
    // MARK: - Cell Type
    
    func typeOfCell(indexPath: NSIndexPath) -> CellType {
        let card = cards[indexPath.section]
        if let rowDataDictionary = card.content[indexPath.row] as? [String: AnyObject] {
           return CellType.typeByKey(rowDataDictionary["key"] as String!)
        }
        
        return .Other
    }
    
}
