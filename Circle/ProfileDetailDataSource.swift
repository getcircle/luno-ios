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

enum ContentType: Int {
    case CellPhone = 1
    case City
    case Country
    case Email
    case Facebook
    case Github
    case LinkedIn
    case Manager
    case Notes
    case Other
    case Tags
    case Team
    case Twitter
}

class SectionItem {
    var title: String
    var image: ItemImage?
    var container: String
    var containerKey: String
    var contentType: ContentType!
    
    init(
        title itemTitle: String,
        container itemContainer: String,
        containerKey itemContainerKey: String,
        contentType type: ContentType,
        image itemImage: ItemImage?
    ) {
        title = itemTitle
        container = itemContainer
        containerKey = itemContainerKey
        image = itemImage
        contentType = type
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

let emptyHeaderReuseIdentifier = "emptyHeaderReuseIdentifier"

class ProfileDetailDataSource: CardDataSource {

    var manager: ProfileService.Containers.Profile?
    var profile: ProfileService.Containers.Profile!
    
    private(set) var address: OrganizationService.Containers.Address?
    private(set) var tags: Array<ProfileService.Containers.Tag>?
    private(set) var team: OrganizationService.Containers.Team?
    private(set) var notes: Array<NoteService.Containers.Note>?

    private(set) var profileHeaderView: ProfileHeaderCollectionReusableView?
    private var sections = [Section]()
    
    convenience init(profile withProfile: ProfileService.Containers.Profile) {
        self.init()
        profile = withProfile
    }
    
    override func registerCardHeader(collectionView: UICollectionView) {
        collectionView.registerClass(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: emptyHeaderReuseIdentifier
        )
        collectionView.registerNib(
            UINib(nibName: "NotesCardHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: NotesCardHeaderCollectionReusableView.classReuseIdentifier
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
            (profile, manager, team, address, tags, notes, error) -> Void in
            if error == nil {
                self.manager = manager
                self.team = team
                self.address = address
                self.tags = tags
                self.notes = notes
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
        sections.append(getNotesSection())
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
                title: "City",
                container: "address",
                containerKey: "city",
                contentType: .City,
                image: nil
            ),
            SectionItem(
                title: "Country",
                container: "address",
                containerKey: "country_code",
                contentType: .Country,
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
                contentType: .Manager,
                image: nil
            ),
            SectionItem(
                title: "Team",
                container: "team",
                containerKey: "name",
                contentType: .Team,
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
                contentType: .Tags,
                image: nil
            )
        ]
        return Section(title: "Tags", items: sectionItems, cardType: .Tags)
    }
    
    private func getNotesSection() -> Section {
        let sectionItems = [
            // XXX we shouldn't have to pass in "containerKey" here
            SectionItem(
                title: "Notes",
                container: "notes",
                containerKey: "content",
                contentType: .Notes,
                image: nil
            )
        ]
        // TODO find a better place to put this
        let headerSize = CGSizeMake(375, 45.0)
        let section = Section(title: "Notes", items: sectionItems, cardType: .Notes, cardHeaderSize: headerSize)
        section.hasAction = true
        return section
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
            sectionCard.headerSize = section.cardHeaderSize
            if sectionCard.content.count > 0 || section.hasAction {
                appendCard(sectionCard)
            }
        }
    }
    
    private func addItemToCard(item: SectionItem, card: Card) {
        switch card.type {
        case .KeyValue: addKeyValueItemToCard(item, card: card)
        case .Tags: addTagsItemToCard(item, card: card)
        case .Notes: addNotesItemToCard(item, card: card)
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
                "value": value,
                "type": item.contentType.rawValue
            ]
            
            if let image = item.image {
                dataDict["image"] = image.name
                dataDict["imageTintColor"] = image.tint
            }
            
            card.addContent(content: [dataDict])
        }
    }
    
    private func addTagsItemToCard(item: SectionItem, card: Card) {
        if let tags = tags {
            card.addContent(content: tags as [AnyObject])
        }
    }
    
    private func addNotesItemToCard(item: SectionItem, card: Card) {
        if let notes = notes {
            card.addContent(content: notes as [AnyObject])
        }
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is TagsCollectionViewCell {
            (cell as TagsCollectionViewCell).showTagsLabel = true
        }
    }
    
    // MARK: - UICollectionViewDataSource

    override func collectionView(
        collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath
    ) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: emptyHeaderReuseIdentifier,
                forIndexPath: indexPath
            ) as UICollectionReusableView
            return supplementaryView
        }
        
        // Display notes card header
        let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: NotesCardHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
        ) as NotesCardHeaderCollectionReusableView
        return supplementaryView
    }
    
    // MARK: - Cell Type
    
    func typeOfCell(indexPath: NSIndexPath) -> ContentType {
        let card = cards[indexPath.section]
        if let rowDataDictionary = card.content[indexPath.row] as? [String: AnyObject] {
           return ContentType(rawValue: (rowDataDictionary["type"] as Int!))!
        }
        
        return .Other
    }
    
    func addNote(note: NoteService.Containers.Note) {
        // TODO this should be an enum or at least a constant
//        if let card = cardAtSection(3) {
//            card.content.insert(note, atIndex: 0)
//        }
    }
    
    func removeNote(note: NoteService.Containers.Note) {
//        if let card = cardAtSection(3) {
//            card.content = card.content.filter {
//                if let item = $0 as? NoteService.Containers.Note {
//                    return item.id != note.id
//                }
//                return true
//            }
//        }
    }
    
}
