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

    class var MaxListEntries: Int {
        return 3
    }
    
    var allowEditingContent = false
    var cardIndex = 0
    var contentCount: Int
    var metaData: AnyObject?
    var sectionInset = UIEdgeInsetsMake(0.0, 10.0, 10.0, 10.0)
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
    private(set) var subType: CardSubType = .None

    enum CardContentType {
        case Flat
        case Aggregate
    }

    enum CardType: String {
        case Anniversaries = "Anniversaries"
        case Banners = "Banners"
        case Birthdays = "Birthdays"
        case Empty = "Empty"
        case Group = "Group"
        case GroupMemberImages = "GroupMemberImages"
        case GroupRequest = "GroupRequest"
        case KeyValue = "KeyValue"
        case Locations = "Locations"
        case LocationsAddress = "Locations Address"
        case NewHires = "NewHires"
        case Profiles = "Profiles"
        case ProfilesGrid = "ProfilesGrid"
        case Placeholder = "Placeholder"
        case Settings = "Settings"
        case SocialConnectCTAs = "SocialConnectCTAs"
        case SocialToggle = "SocialToggle"
        case SearchSuggestion = "SearchSuggestion"
        case ContactMethods = "ContactMethods"
        case TextValue = "TextValue"

        struct CardTypeInfo {
            var imageName: String
            var classType: CircleCollectionViewCell.Type
            var contentType: CardContentType
        }

        static func infoByCardType(type: CardType) -> CardTypeInfo {
            switch type {

            case Anniversaries:
                return CardTypeInfo(
                    imageName: "FeedWork",
                    classType: ProfileCollectionViewCell.self,
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

            case Group:
                return CardTypeInfo(
                    imageName: "detail_group",
                    classType: GroupCollectionViewCell.self,
                    contentType: .Flat
                )
                
            case GroupMemberImages:
                return CardTypeInfo(
                    imageName: "detail_group",
                    classType: ProfileImagesCollectionViewCell.self,
                    contentType: .Aggregate
                )
                
            case GroupRequest:
                return CardTypeInfo(
                    imageName: "FeedNotification",
                    classType: GroupRequestCollectionViewCell.self,
                    contentType: .Flat
                )

            case KeyValue:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: KeyValueCollectionViewCell.self,
                    contentType: .Flat
                )

            case Locations:
                return CardTypeInfo(
                    imageName: "detail_location",
                    classType: LocationCollectionViewCell.self,
                    contentType: .Flat
                )

            case LocationsAddress:
                return CardTypeInfo(
                    imageName: "detail_location",
                    classType: AddressCollectionViewCell.self,
                    contentType: .Flat
                )

            case Profiles:
                return CardTypeInfo(
                    imageName: "detail_group",
                    classType: ProfileCollectionViewCell.self,
                    contentType: .Flat
                )

            case ProfilesGrid:
                return CardTypeInfo(
                    imageName: "detail_group",
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

            case Settings:
                return CardTypeInfo(
                    imageName: "Settings",
                    classType: SettingsCollectionViewCell.self,
                    contentType: .Flat
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

            case SearchSuggestion:
                return CardTypeInfo(
                    imageName: String(),
                    classType: SearchSuggestionCollectionViewCell.self,
                    contentType: .Flat
                )

            case .ContactMethods:
                return CardTypeInfo(
                    imageName: "Info",
                    classType: ContactCollectionViewCell.self,
                    contentType: .Flat
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
    
    enum CardSubType: String {
        case Members = "Members"
        case Teams = "Teams"
        case ManagedTeams = "ManagedTeams"
        case PointsOfContact = "PointsOfContact"
        case None = "None"
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
    
    convenience init(
        cardType: CardType,
        subType withSubType: CardSubType,
        title withTitle: String,
        contentCount withContentCount: Int? = nil
    ){
        self.init(
            cardType: cardType,
            title: withTitle,
            content: nil,
            contentCount: withContentCount,
            addDefaultFooter:  false,
            showContentCount: false
        )
        
        subType = withSubType
    }


    func addContent(content withContent: [AnyObject], maxVisibleItems withMaxVisibleItems: Int) {
        switch cardContentType {
        case .Aggregate:
            content.append(withContent)

        default:
            content.appendContentsOf(withContent)
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
        addFooter(
            footerClass: CardFooterCollectionReusableView.self
        )
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
                content = Array(allContent[0..<maxVisibleItems])
            }
            else if cardContentType == .Aggregate && content.first!.count > maxVisibleItems {
                content[0] = Array((allContent.first! as![AnyObject])[0..<maxVisibleItems])
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
