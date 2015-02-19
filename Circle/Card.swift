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

    var cardIndex = 0
    var contentCount: Int
    var headerSize = CGSizeZero
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
    private(set) var addFooter = false
    private(set) var content = [AnyObject]()
    private(set) var contentClass: CircleCollectionViewCell.Type
    private(set) var contentClassName: String
    private(set) var cardContentType: CardContentType
    private(set) var footerClass: CircleCollectionReusableView.Type?
    // Yup, this is ugly but swift makes us do this
    private(set) var footerClassName: String?
    private(set) var footerSize = CGSizeZero
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
        case Birthdays = "Birthdays"
        case Education = "Education"
        case Group = "Group"
        case KeyValue = "KeyValue"
        case Offices = "Offices"
        case NewHires = "NewHires"
        case Notes = "Notes"
        case People = "People"
        case Placeholder = "Placeholder"
        case Position = "Position"
        case Settings = "Settings"
        case Skills = "Skills"
        case SocialConnectCTAs = "SocialConnectCTAs"
        case SocialToggle = "SocialToggle"
        case QuickActions = "QuickActions"
        case Team = "Team"
        case TeamsGrid = "TeamsGrid"
        case TextValue = "TextValue"

        struct CardTypeInfo {
            var imageName: String
            var classType: CircleCollectionViewCell.Type
            var className: String
            var contentType: CardContentType
        }

        static func infoByCardType(type: CardType) -> CardTypeInfo {
            switch type {

            case .AddNote:
                return CardTypeInfo(
                    imageName: "Plus",
                    classType: AddNoteCollectionViewCell.self,
                    className: "AddNoteCollectionViewCell",
                    contentType: .Flat
                )

            case .Anniversaries:
                return CardTypeInfo(
                    imageName: "Jewel",
                    classType: ProfileCollectionViewCell.self,
                    className: "ProfileCollectionViewCell",
                    contentType: .Flat
                )

            case .Birthdays:
                return CardTypeInfo(
                    imageName: "Cake",
                    classType: ProfileCollectionViewCell.self,
                    className: "ProfileCollectionViewCell",
                    contentType: .Flat
                )

            case .Education:
                return CardTypeInfo(
                    imageName: "GraduateCap",
                    classType: EducationCollectionViewCell.self,
                    className: "EducationCollectionViewCell",
                    contentType: .Flat
                )

            case Group:
                return CardTypeInfo(
                    imageName: "People",
                    classType: ProfileImagesCollectionViewCell.self,
                    className: "ProfileImagesCollectionViewCell",
                    contentType: .Aggregate
                )

            case KeyValue:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: KeyValueCollectionViewCell.self,
                    className: "KeyValueCollectionViewCell",
                    contentType: .Flat
                )

            case Offices:
                return CardTypeInfo(
                    imageName: "MapPin",
                    classType: OfficeCollectionViewCell.self,
                    className: "OfficeCollectionViewCell",
                    contentType: .Flat
                )

            case Notes:
                return CardTypeInfo(
                    imageName: "Notepad",
                    classType: NotesCollectionViewCell.self,
                    className: "NotesCollectionViewCell",
                    contentType: .Flat
                )

            case .People:
                return CardTypeInfo(
                    imageName: "People",
                    classType: ProfileCollectionViewCell.self,
                    className: "ProfileCollectionViewCell",
                    contentType: .Flat
                )

            case .NewHires:
                return CardTypeInfo(
                    imageName: "People",
                    classType: ProfileCollectionViewCell.self,
                    className: "ProfileCollectionViewCell",
                    contentType: .Flat
                )

            case .Placeholder:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: CircleCollectionViewCell.self,
                    className: "CircleCollectionViewCell",
                    contentType: .Flat
                )

            case .Position:
                return CardTypeInfo(
                    imageName: "Satchel",
                    classType: PositionCollectionViewCell.self,
                    className: "PositionCollectionViewCell",
                    contentType: .Flat
                )

            case .Settings:
                return CardTypeInfo(
                    imageName: "Cog",
                    classType: SettingsCollectionViewCell.self,
                    className: "SettingsCollectionViewCell",
                    contentType: .Flat
                )

            case .Skills:
                return CardTypeInfo(
                    imageName: "Tag",
                    classType: SkillsCollectionViewCell.self,
                    className: "SkillsCollectionViewCell",
                    contentType: .Aggregate
                )

            case .SocialConnectCTAs:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: SocialConnectCollectionViewCell.self,
                    className: "SocialConnectCollectionViewCell",
                    contentType: .Flat
                )

            case .SocialToggle:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: ToggleSocialConnectionCollectionViewCell.self,
                    className: "ToggleSocialConnectionCollectionViewCell",
                    contentType: .Flat
                )

            case .QuickActions:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: QuickActionsCollectionViewCell.self,
                    className: "QuickActionsCollectionViewCell",
                    contentType: .Flat
                )

            case .Team:
                return CardTypeInfo(
                    imageName: "People",
                    classType: TeamGridItemCollectionViewCell.self,
                    className: "TeamGridItemCollectionViewCell",
                    contentType: .Flat
                )

            case .TeamsGrid:
                return CardTypeInfo(
                    imageName: "People",
                    classType: TeamsCollectionViewCell.self,
                    className: "TeamsCollectionViewCell",
                    contentType: .Aggregate
                )

            case .TextValue:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: TextValueCollectionViewCell.self,
                    className: "TextValueCollectionViewCell",
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
        addDefaultFooter withFooter: Bool?
    ) {
        type = cardType
        let infoByCardType = CardType.infoByCardType(type)
        imageSource = infoByCardType.imageName
        contentClass = infoByCardType.classType
        contentClassName = infoByCardType.className
        cardContentType = infoByCardType.contentType
        title = withTitle
        contentCount = withContentCount ?? 0
        content = withContent ?? []
        allContent = content

        if let addADefaultFooter = withFooter {
            if addADefaultFooter {
                addDefaultFooter()
            }
        }
    }

    convenience init(cardType: CardType, title withTitle: String, addDefaultFooter: Bool? = false) {
        self.init(
            cardType: cardType,
            title: withTitle,
            content: nil,
            contentCount: nil,
            addDefaultFooter: addDefaultFooter ?? false
        )
    }

    convenience init(category: LandingService.Containers.Category, addDefaultFooter: Bool? = false) {
        var cardType: CardType

        switch category.type {
        case .Anniversaries:
            cardType = .Anniversaries
        case .Birthdays:
            cardType = .Birthdays
        case .NewHires:
            cardType = .NewHires
        case .Notes:
            cardType = .Notes
        case .DirectReports, .Peers:
            cardType = .Group
        case .Locations:
            cardType = .Offices
        case .Skills:
            cardType = .Skills
        case .Executives:
            cardType = .People
        case .Departments:
            cardType = .TeamsGrid
        default:
            cardType = .People
        }

        self.init(
            cardType: cardType,
            title: category.title,
            content: nil,
            contentCount: category.total_count.toInt(),
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
        addFooter(
            footerClass: CardFooterCollectionReusableView.self,
            footerClassName: "CardFooterCollectionReusableView"
        )
    }

    func addFooter(
        footerClass withFooterClass: CircleCollectionReusableView.Type,
        footerClassName withFooterClassName: String
    ) {
        addFooter = true
        footerClass = withFooterClass
        footerClassName = withFooterClassName
        footerSize = CGSizeMake(
            withFooterClass.width - sectionInset.left - sectionInset.right,
            withFooterClass.height + sectionInset.bottom
        )

        sectionInset = UIEdgeInsetsMake(
            sectionInset.top,
            sectionInset.left,
            1.0,
            sectionInset.right
        )
    }

    func setContentToVisibleItems() {
        if maxVisibleItems > 0 {

            if cardContentType == .Flat && content.count > maxVisibleItems {
                content = Array(content[0..<maxVisibleItems])
            }
            else if cardContentType == .Aggregate && content.first!.count > maxVisibleItems {
                content[0] = Array((content.first! as [AnyObject])[0..<maxVisibleItems])
            }
        }
    }

    func setContentToAllContent() {
        content = allContent
    }
}
