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
    var size: CGSize?
    
    class var genericNextImage: ItemImage {
        return ItemImage(name: "Next", tint: UIColor.keyValueNextImageTintColor(), size: CGSizeMake(15.0, 15.0))
    }
    
    init(name itemName: String, tint itemTint: UIColor, size imageSize: CGSize? = nil) {
        name = itemName
        tint = itemTint
        size = imageSize
    }
}

enum ContentType: Int {
    case CellPhone = 1
    case Email
    case Facebook
    case Github
    case LinkedIn
    case LinkedInConnect
    case Location
    case Manager
    case Other
    case Skills
    case Team
    case Twitter
}

class SectionItem {
    var title: String
    var image: ItemImage?
    var container: String
    var containerKey: String
    var contentType: ContentType!
    var defaultValue: Any?
    
    init(
        title itemTitle: String,
        container itemContainer: String,
        containerKey itemContainerKey: String,
        contentType type: ContentType,
        image itemImage: ItemImage?,
        defaultValue itemDefaultValue: Any? = nil
    ) {
        title = itemTitle
        container = itemContainer
        containerKey = itemContainerKey
        image = itemImage
        contentType = type
        defaultValue = itemDefaultValue
    }
}

class Section {
    var title: String
    var items: [SectionItem]
    var cardType: Card.CardType
    var cardHeaderSize: CGSize
    var hasAction = false
    
    init(
        title sectionTitle: String,
        items sectionItems: [SectionItem],
        cardType sectionCardType: Card.CardType,
        cardHeaderSize sectionCardHeaderSize: CGSize = CGSizeZero
    ) {
        title = sectionTitle
        items = sectionItems
        cardType = sectionCardType
        cardHeaderSize = sectionCardHeaderSize
    }
}

class ProfileDetailDataSource: UnderlyingCollectionViewDataSource {

    var profile: ProfileService.Containers.Profile!
    
    private(set) var address: OrganizationService.Containers.Address?
    private(set) var manager: ProfileService.Containers.Profile?
    private(set) var skills: Array<ProfileService.Containers.Skill>?
    private(set) var team: OrganizationService.Containers.Team?

    private(set) var profileHeaderView: ProfileHeaderCollectionReusableView?
    private var sections = [Section]()
    
    convenience init(profile withProfile: ProfileService.Containers.Profile) {
        self.init()
        profile = withProfile
    }
    
    override func registerCardHeader(collectionView: UICollectionView) {
        // TODO should have some like "onLoad" function we can plug into
        configureSections()
        super.registerCardHeader(collectionView)
    }

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        // Add placeholder card to load profile header instantly
        var placeholderCard = Card(cardType: .Placeholder, title: "Info")
        appendCard(placeholderCard)
        ProfileService.Actions.getExtendedProfile(profile.id) {
            (profile, manager, team, address, skills, _, error) -> Void in
            if error == nil {
                self.manager = manager
                self.team = team
                self.address = address
                self.skills = skills
                self.populateData()
            }
            completionHandler(error: error)
        }
    }
    
    // MARK: - Configuration
    
    private func configureSections() {
        if let socialConnectSection = getSocialConnectSection() {
            sections.append(socialConnectSection)
        }
        sections.append(getBasicInfoSection())
        sections.append(getManagerInfoSection())
        sections.append(getSkillsSection())
    }
    
    private func getSocialConnectSection() -> Section? {
        if profile.id == AuthViewController.getLoggedInUserProfile()!.id {
            let sectionItems = [
                SectionItem(
                    title: NSLocalizedString("Connect with LinkedIn", comment: "Button title for connect with LinkedIn button"),
                    container: "social",
                    containerKey: "profile",
                    contentType: .LinkedInConnect,
                    image: ItemImage(name: "LinkedIn", tint: UIColor.linkedinColor())
                )
            ]
            return Section(title: "Social", items: sectionItems, cardType: .SocialConnectCTAs)
        }
        
        return nil
    }
    
    private func getBasicInfoSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "Email",
                container: "profile",
                containerKey: "email",
                contentType: .Email,
                image: ItemImage(name: "EmailCircle", tint: UIColor.emailTintColor())
            ),
            SectionItem(
                title: "Cell Phone",
                container: "profile",
                containerKey: "cell_phone",
                contentType: .CellPhone,
                image: ItemImage(name: "Telephone", tint: UIColor.phoneTintColor())
            ),
            SectionItem(
                title: "Location",
                container: "address",
                containerKey: "city",
                contentType: .Location,
                image: ItemImage.genericNextImage
            ),
        ]
        return Section(title: "Info", items: sectionItems, cardType: .KeyValue)
    }
    
    private func getManagerInfoSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "Manager",
                container: "manager",
                containerKey: "full_name",
                contentType: .Manager,
                image: ItemImage.genericNextImage
            ),
            SectionItem(
                title: "Team",
                container: "team",
                containerKey: "name",
                contentType: .Team,
                image: ItemImage.genericNextImage
            )
        ]
        return Section(title: "Manager Info", items: sectionItems, cardType: .KeyValue)
    }
    
    private func getSkillsSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "Skills",
                container: "skills",
                containerKey: "name",
                contentType: .Skills,
                image: nil
            )
        ]
        return Section(title: "Skills", items: sectionItems, cardType: .Skills)
    }
    
    // MARK: - Populate Data
    
    private func populateData() {
        resetCards()
        
        var defaultSectionInset = UIEdgeInsetsMake(12.0, 0.0, 12.0, 0.0)
        for section in sections {
            let sectionCard = Card(cardType: section.cardType, title: section.title)
            for item in section.items {
                addItemToCard(item, card: sectionCard)
            }
            
            sectionCard.sectionInset = defaultSectionInset
            sectionCard.headerSize = section.cardHeaderSize
            if sectionCard.content.count > 0 || section.hasAction {
                appendCard(sectionCard)
            }
        }
    }
    
    private func addItemToCard(item: SectionItem, card: Card) {
        switch card.type {
        case .KeyValue:
            addKeyValueItemToCard(item, card: card)
        case .Skills:
            addSkillsItemToCard(item, card: card)
        case .SocialConnectCTAs:
            addSocialConnectItemToCard(item, card: card)
        default: break
        }
    }
    
    private func addKeyValueItemToCard(item: SectionItem, card: Card) {
        var value: Any? = item.defaultValue
        switch item.container {
        case "profile":
            value = profile[item.containerKey]
        case "manager":
            value = manager?[item.containerKey]
            // Handle CEO where manager doesn't exist
            if let stringValue = value as? String {
                if stringValue == "" {
                    value = nil
                }
            }
        case "address":
            value = address?[item.containerKey]
        case "team":
            value = team?[item.containerKey]
        default:
            break
        }
        
        if let value = value as? String {
            var dataDict: [String: AnyObject] = [
                "key": item.containerKey,
                "name": item.title,
                "value": value,
                "type": item.contentType.rawValue
            ]
            
            if let image = item.image {
                dataDict["image"] = image.name
                dataDict["imageTintColor"] = image.tint
                if let imageSize = image.size {
                    dataDict["imageSize"] = NSValue(CGSize: imageSize)
                }
            }
            
            card.addContent(content: [dataDict])
        }
    }
    
    private func addSkillsItemToCard(item: SectionItem, card: Card) {
        if let skills = skills {
            card.addContent(content: skills as [AnyObject])
        }
    }
    
    private func addSocialConnectItemToCard(item: SectionItem, card: Card) {
        var dataDict: [String: AnyObject] = [
            "key": item.containerKey,
            "title": item.title,
            "type": item.contentType.rawValue
        ]

        card.addContent(content: [dataDict])
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is SkillsCollectionViewCell {
            (cell as SkillsCollectionViewCell).showSkillsLabel = true
        }
    }
    
    // MARK: - Cell Type
    
    func typeOfCell(indexPath: NSIndexPath) -> ContentType {
        let card = cards[indexPath.section]
        if let rowDataDictionary = card.content[indexPath.row] as? [String: AnyObject] {
           return ContentType(rawValue: (rowDataDictionary["type"] as Int!))!
        }
        
        return .Other
    }
    
}
