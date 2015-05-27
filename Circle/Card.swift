//
//  Card.swift
//  Circle
//
//  Created by Ravi Rani on 12/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

func ==(lhs: Card, rhs: Card) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

class Card: Equatable {

    var allowEditingContent = false
    var cardIndex = 0
    var contentCount: Int
    var metaData: AnyObject?
    var sectionInset = UIEdgeInsetsMake(1.0, 10.0, 25.0, 10.0)
    var showAllContent: Bool = false {
        didSet {
            if showAllContent {
                content = allContent
            }
            else if maxVisibleItems > 0 && content.count > maxVisibleItems {
                allContent = content
                content = Array(content[0..<maxVisibleItems])
            }
        }
    }
    var showContentCount = true

    private(set) var allContent = [AnyObject]()
    private(set) var addHeader = false
    private(set) var addFooter = false
    private(set) var cardContentType: CardContentType
    private(set) var content = [AnyObject]()
    private(set) var contentClass: CircleCollectionViewCell.Type
    private(set) var contentClassName: String
    private(set) var footerClass: CircleCollectionReusableView.Type?
    private(set) var footerClassName: String?
    private(set) var footerSize = CGSizeZero
    private(set) var headerClass: CircleCollectionReusableView.Type?
    private(set) var headerClassName: String?
    private(set) var headerSize = CGSizeZero
    private(set) var imageSource: String
    private(set) var maxVisibleItems: Int = 0 {
        didSet {
            if maxVisibleItems > 0 {
                setContentToVisibleItems()
            }
            else {
                setContentToAllContent()
            }
        }
    }
    private(set) var title: String
    private(set) var type: CardType

    enum CardContentType {
        case Flat
        case Aggregate
    }

    enum CardType: String {
        case AddNote = "AddNote"
        case Anniversaries = "Anniversaries"
        case Appreciate = "Appreciate"
        case Appreciations = "Appreciations"
        case Banners = "Banners"
        case Birthdays = "Birthdays"
        case Empty = "Empty"
        case Education = "Education"
        case Group = "Group"
        case GroupMemberImages = "GroupMemberImages"
        case GroupRequest = "GroupRequest"
        case KeyValue = "KeyValue"
        case Tags = "Tags"
        case Offices = "Offices"
        case OfficeAddress = "Office Address"
        case NewHires = "NewHires"
        case Notes = "Notes"
        case Profiles = "Profiles"
        case ProfilesGrid = "ProfilesGrid"
        case Placeholder = "Placeholder"
        case Position = "Position"
        case Settings = "Settings"
        case SocialConnectCTAs = "SocialConnectCTAs"
        case SocialToggle = "SocialToggle"
        case StatTile = "StatTile"
        case QuickActions = "QuickActions"
        case Team = "Team"
        case TeamsGrid = "TeamsGrid"
        case TextValue = "TextValue"
        case Skills = "Skills"

        struct CardTypeInfo {
            var imageName: String
            var classType: CircleCollectionViewCell.Type
            var contentType: CardContentType
        }

        static func infoByCardType(type: CardType) -> CardTypeInfo {
            switch type {

            case AddNote:
                return CardTypeInfo(
                    imageName: "Plus",
                    classType: AddNoteCollectionViewCell.self,
                    contentType: .Flat
                )

            case Anniversaries:
                return CardTypeInfo(
                    imageName: "FeedWork",
                    classType: ProfileCollectionViewCell.self,
                    contentType: .Flat
                )

            case Appreciate:
                return CardTypeInfo(
                    imageName: "Heart",
                    classType: AppreciateActionCollectionViewCell.self,
                    contentType: .Flat
                )

            case Appreciations:
                return CardTypeInfo(
                    imageName: "Heart",
                    classType: AppreciationCollectionViewCell.self,
                    contentType: .Flat
                )

            case Banners:
                return CardTypeInfo(
                    imageName: "Balloons",
                    classType: BannerCollectionViewCell.self,
                    contentType: .Flat
                )

            case Birthdays:
                return CardTypeInfo(
                    imageName: "FeedBirthday",
                    classType: ProfileCollectionViewCell.self,
                    contentType: .Flat
                )

            case Empty:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: EmptyCollectionViewCell.self,
                    contentType: .Flat
                )

            case Education:
                return CardTypeInfo(
                    imageName: "GraduateCap",
                    classType: EducationCollectionViewCell.self,
                    contentType: .Flat
                )

            case Group:
                return CardTypeInfo(
                    imageName: "FeedPeers",
                    classType: GroupCollectionViewCell.self,
                    contentType: .Flat
                )
                
            case GroupMemberImages:
                return CardTypeInfo(
                    imageName: "FeedPeers",
                    classType: ProfileImagesCollectionViewCell.self,
                    contentType: .Aggregate
                )
                
            case GroupRequest:
                return CardTypeInfo(
                    imageName: "FeedNotification",
                    classType: GroupRequestCollectionViewCell.self,
                    contentType: .Flat
                )

            case Tags:
                return CardTypeInfo(
                    imageName: "FeedSkills",
                    classType: TagScrollingCollectionViewCell.self,
                    contentType: .Aggregate
                )

            case KeyValue:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: KeyValueCollectionViewCell.self,
                    contentType: .Flat
                )

            case Offices:
                return CardTypeInfo(
                    imageName: "FeedLocation",
                    classType: OfficeCollectionViewCell.self,
                    contentType: .Flat
                )

            case OfficeAddress:
                return CardTypeInfo(
                    imageName: "FeedLocation",
                    classType: AddressCollectionViewCell.self,
                    contentType: .Flat
                )

            case Notes:
                return CardTypeInfo(
                    imageName: "Notepad",
                    classType: NotesCollectionViewCell.self,
                    contentType: .Flat
                )

            case Profiles:
                return CardTypeInfo(
                    imageName: "Users",
                    classType: ProfileCollectionViewCell.self,
                    contentType: .Flat
                )

            case ProfilesGrid:
                return CardTypeInfo(
                    imageName: "Users",
                    classType: ProfileGridItemCollectionViewCell.self,
                    contentType: .Flat
                )
                
            case NewHires:
                return CardTypeInfo(
                    imageName: "FeedNewHire",
                    classType: ProfileCollectionViewCell.self,
                    contentType: .Flat
                )

            case Placeholder:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: CircleCollectionViewCell.self,
                    contentType: .Flat
                )

            case Position:
                return CardTypeInfo(
                    imageName: "Satchel",
                    classType: PositionCollectionViewCell.self,
                    contentType: .Flat
                )

            case Settings:
                return CardTypeInfo(
                    imageName: "Settings",
                    classType: SettingsCollectionViewCell.self,
                    contentType: .Flat
                )

            case Skills:
                return CardTypeInfo(
                    imageName: "FeedSkills",
                    classType: TagScrollingCollectionViewCell.self,
                    contentType: .Aggregate
                )

            case SocialConnectCTAs:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: SocialConnectCollectionViewCell.self,
                    contentType: .Flat
                )

            case SocialToggle:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: ToggleSocialConnectionCollectionViewCell.self,
                    contentType: .Flat
                )

            case StatTile:
                return CardTypeInfo(
                    imageName: String(),
                    classType: StatTileCollectionViewCell.self,
                    contentType: .Flat
                )

            case QuickActions:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: QuickActionsCollectionViewCell.self,
                    contentType: .Flat
                )

            case Team:
                return CardTypeInfo(
                    imageName: "FeedTeam",
                    classType: TeamGridItemCollectionViewCell.self,
                    contentType: .Flat
                )

            case TeamsGrid:
                return CardTypeInfo(
                    imageName: "FeedTeam",
                    classType: TeamsCollectionViewCell.self,
                    contentType: .Aggregate
                )

            case TextValue:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: TextValueCollectionViewCell.self,
                    contentType: .Flat
                )
            }
        }
    }

    required init(
        cardType: CardType,
        title withTitle: String,
        content withContent: [AnyObject]?,
        contentCount withContentCount: Int?,
        addDefaultFooter withFooter: Bool?,
        showContentCount withShowContentCount: Bool? = true
    ) {
        type = cardType
        let infoByCardType = CardType.infoByCardType(type)
        imageSource = infoByCardType.imageName
        contentClass = infoByCardType.classType
        contentClassName = contentClass.classReuseIdentifier
        cardContentType = infoByCardType.contentType
        title = withTitle
        contentCount = withContentCount ?? 0
        content = withContent ?? []
        allContent = content
        if withShowContentCount != nil {
            showContentCount = withShowContentCount!
        }

        if let addADefaultFooter = withFooter {
            if addADefaultFooter {
                addDefaultFooter()
            }
        }
    }

    convenience init(
        cardType: CardType,
        title withTitle: String,
        addDefaultFooter: Bool? = false,
        contentCount withContentCount: Int? = nil,
        showContentCount withShowContentCount: Bool? = true
    ) {
        self.init(
            cardType: cardType,
            title: withTitle,
            content: nil,
            contentCount: withContentCount,
            addDefaultFooter: addDefaultFooter ?? false,
            showContentCount: withShowContentCount
        )
    }

    convenience init(category: Services.Feed.Containers.CategoryV1, addDefaultFooter: Bool? = false) {
        var cardType: CardType

        switch category.categoryType {
        case .Anniversaries:
            cardType = .Anniversaries
        case .Birthdays:
            cardType = .Birthdays
        case .NewHires:
            cardType = .NewHires
        case .Notes:
            cardType = .Notes
        case .DirectReports, .Peers:
            cardType = .GroupMemberImages
        case .Locations:
            cardType = .Offices
        case .Interests, .Skills:
            cardType = .Tags
        case .Executives:
            cardType = .Profiles
        case .Departments:
            cardType = .TeamsGrid
        case .GroupMembershipRequests:
            cardType = .GroupRequest
        default:
            cardType = .Profiles
        }

        self.init(
            cardType: cardType,
            title: category.title,
            content: nil,
            contentCount: String(category.totalCount).toInt() ?? 0,
            addDefaultFooter: addDefaultFooter ?? false
        )
    }

    func addContent(content withContent: [AnyObject], maxVisibleItems withMaxVisibleItems: Int) {
        switch cardContentType {
        case .Aggregate:
            content.append(withContent)

        default:
            content.extend(withContent)
        }

        allContent = content
        maxVisibleItems = withMaxVisibleItems
    }

    func addContent(content withContent: [AnyObject]) {
        self.addContent(content: withContent, maxVisibleItems: 0)
    }

    func resetContent() {
        content = []
        allContent = []
        contentCount = 0
    }

    func resetContent(newContent: [AnyObject]) {
        resetContent()
        addContent(content: newContent)
    }

    func hasProfileCells() -> Bool {
        return self.contentClass is ProfileCollectionViewCell.Type
    }

    func isContentAllContent() -> Bool {
        switch cardContentType {
        case .Flat:
            return allContent.count == content.count && content.count > 0

        case .Aggregate:
            if content.count > 0 {
                return allContent[0].count == content[0].count && content[0].count > 0
            }
        }

        return false
    }

    func addDefaultFooter() {
        if !isContentAllContent() {
            addFooter(
                footerClass: CardFooterCollectionReusableView.self
            )
        }
    }

    func addFooter(footerClass withFooterClass: CircleCollectionReusableView.Type) {
        addFooter = true
        footerClass = withFooterClass
        footerClassName = withFooterClass.classReuseIdentifier
        footerSize = CGSizeMake(
            withFooterClass.width - sectionInset.left - sectionInset.right,
            withFooterClass.height + sectionInset.bottom
        )

        sectionInset = UIEdgeInsetsMake(
            sectionInset.top,
            sectionInset.left,
            0.0,
            sectionInset.right
        )
    }

    func addDefaultHeader() {
        addHeader(
            headerClass: CardHeaderCollectionReusableView.self
        )
    }

    func addHeader(
        headerClass withHeaderClass: CircleCollectionReusableView.Type,
        headerSize withHeaderSize: CGSize? = nil
    ) {
        addHeader = true
        headerClass = withHeaderClass
        headerClassName = withHeaderClass.classReuseIdentifier
        if let providedHeaderSize = withHeaderSize {
            headerSize = providedHeaderSize
        }
        else {
            headerSize = CGSizeMake(
                withHeaderClass.width - sectionInset.left - sectionInset.right,
                withHeaderClass.height
            )
        }
    }

    func setContentToVisibleItems() {
        if maxVisibleItems > 0 {

            if cardContentType == .Flat && content.count > maxVisibleItems {
                content = Array(content[0..<maxVisibleItems])
            }
            else if cardContentType == .Aggregate && content.first!.count > maxVisibleItems {
                content[0] = Array((content.first! as![AnyObject])[0..<maxVisibleItems])
            }
        }
    }

    func setContentToAllContent() {
        content = allContent
    }

    func toggleShowingFullContent() {
        if isContentAllContent() {
            setContentToVisibleItems()
        }
        else {
            setContentToAllContent()
        }
    }

    func contentCountLabel() -> String {
        if showContentCount {
            return contentCount == 1 ? "" : "All " + String(contentCount)
        }
        return String()
    }

}
