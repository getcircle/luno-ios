//
//  ProfileDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileDetailDataSource: CardDataSource {

    var addBannerOfType: BannerType?
    var profile: Services.Profile.Containers.ProfileV1!
    var profileHeaderView: ProfileHeaderCollectionReusableView?

    internal var sections = [Section]()
    
    private(set) var address: Services.Organization.Containers.AddressV1?
    private(set) var identities: Array<Services.User.Containers.IdentityV1>?
    private(set) var interests: Array<Services.Profile.Containers.TagV1>?
    private(set) var groups: Array<Services.Group.Containers.GroupV1>?
    private(set) var location: Services.Organization.Containers.LocationV1?
    private(set) var manager: Services.Profile.Containers.ProfileV1?
    private(set) var skills: Array<Services.Profile.Containers.TagV1>?
    private(set) var team: Services.Organization.Containers.TeamV1?
    private(set) var resume: Services.Resume.Containers.ResumeV1?

    private let numberOfEducationItemsVisibleInitially = 1
    private let numberOfExperienceItemsVisibleInitially = 2
    private let numberOfTagItemsVisibleInitially = 6
    private let numberOfSkillItemsVisibleInitially = 6
    private let numberOfGroupItemsVisibleInitially = 3
    
    convenience init(profile withProfile: Services.Profile.Containers.ProfileV1) {
        self.init()
        profile = withProfile
    }
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()
        addPlaceholderCard()
        Services.Profile.Actions.getExtendedProfile(profile.id) {
            (profile, manager, team, address, interests, skills, notes, identities, resume, location, groups, error) -> Void in
            if error == nil {
                self.manager = manager
                self.team = team
                self.address = address
                self.skills = skills
                self.interests = interests
                self.identities = identities
                self.resume = resume
                self.location = location
                self.groups = groups
                self.populateData()
            }
            completionHandler(error: error)
        }
    }
    
    // MARK: - Configuration
    
    internal func configureSections() {
        sections.removeAll(keepCapacity: true)
        sections.append(getQuickActionsSection())
        if let addBanner = addBannerOfType {
            if !isProfileLoggedInUserProfile() {
                // sections.append(getBannersSection())
            }
        }
        sections.append(getAboutSection())
        sections.append(getSkillsSection())
        sections.append(getManagerSection())
        sections.extend(getOfficeSections())
        sections.append(getInterestsSection())
        sections.append(getBasicInfoSection())
        sections.append(getWorkExperienceSection())
        sections.append(getEducationSection())
//        sections.append(getGroupsSection())
    }

    private func addPlaceholderCard() {
        
        // Add placeholder card to load profile header instantly
        var placeholderCard = Card(cardType: .Placeholder, title: "Info")
        placeholderCard.addHeader(
            headerClass: ProfileHeaderCollectionReusableView.self
        )
        placeholderCard.sectionInset = UIEdgeInsetsZero
        appendCard(placeholderCard)
    }
    
    private func getQuickActionsSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "Quick Actions",
                container: "",
                containerKey: "",
                contentType: .QuickActions,
                image: nil
            )
        ]
        return Section(title: "Quick Actions", items: sectionItems, cardType: .QuickActions)
    }
    
    private func getBannersSection() -> Section {
        // TODO: Check birthday / anniversary and customize
        let sectionItems = [
            SectionItem(
                title: "Banner",
                container: "",
                containerKey: "",
                contentType: .Banner,
                image: nil
            )
        ]
        return Section(title: "Banner", items: sectionItems, cardType: .Banners)
    }

    internal func getAboutSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "About",
                container: "profile",
                containerKey: "about",
                contentType: .About,
                image: nil
            )
        ]
        return Section(title: "About", items: sectionItems, cardType: .TextValue)
    }
    
    private func getBasicInfoSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "Hire Date",
                container: "profile",
                containerKey: "hireDate",
                contentType: .HireDate,
                image: nil
            ),
            SectionItem(
                title: "Birthday",
                container: "profile",
                containerKey: "birthDate",
                contentType: .Birthday,
                image: nil
            )
        ]
        return Section(title: AppStrings.ProfileSectionInfoTitle, items: sectionItems, cardType: .KeyValue, addCardHeader: true)
    }
    
    private func getGroupsSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: AppStrings.ProfileSectionGroupsTitle,
                container: "groups",
                containerKey: "count",
                contentType: .Groups,
                image: ItemImage.genericNextImage
            )
        ]
        
        return Section(title: AppStrings.ProfileSectionGroupsTitle, items: sectionItems, cardType: .KeyValue, addCardHeader: false)
    }

    private func getOfficeSections() -> [Section] {
        let placeholderItem = [
            SectionItem(
                title: "Placeholder",
                container: "",
                containerKey: "",
                contentType: .Other,
                image: nil
            )
        ]
        let placeholderSection = Section(
            title: AppStrings.ProfileSectionOfficeTitle,
            items: placeholderItem,
            cardType: .Placeholder,
            addCardHeader: true
        )

        let seatingInfoItem = [
            SectionItem(
                title: "Seating Info",
                container: "profile",
                containerKey: "seating_info",
                contentType: .SeatingInfo,
                image: nil
            )
        ]
        let seatingInfoSection = Section(
            title: AppStrings.ProfileSectionOfficeTitle, 
            items: seatingInfoItem, 
            cardType: .KeyValue
        )

        let officeLocationItem = [
            SectionItem(
                title: AppStrings.ProfileSectionOfficeTitle,
                container: "",
                containerKey: "",
                contentType: .OfficeTeam,
                image: ItemImage.genericNextImage
            )
        ]
        let officeSection = Section(title: "", items: officeLocationItem, cardType: .Profiles)
        return [placeholderSection, seatingInfoSection, officeSection]
    }

    private func getManagerSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: AppStrings.ProfileSectionManagerTeamTitle,
                container: "",
                containerKey: "",
                contentType: .Manager,
                image: ItemImage.genericNextImage
            )
        ]
        return Section(title: AppStrings.ProfileSectionManagerTeamTitle, items: sectionItems, cardType: .Profiles, addCardHeader: true)
    }
    
    private func getSkillsSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: AppStrings.ProfileSectionExpertiseTitle,
                container: "skills",
                containerKey: "name",
                contentType: .Skills,
                image: nil
            )
        ]
        
        return Section(title: AppStrings.ProfileSectionExpertiseTitle, items: sectionItems, cardType: .Skills, addCardHeader: true, allowEmptyContent: true)
    }
    
    private func getInterestsSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: AppStrings.ProfileSectionInterestsTitle,
                container: "interests",
                containerKey: "name",
                contentType: .Interests,
                image: nil
            )
        ]
        
        return Section(title: AppStrings.ProfileSectionInterestsTitle, items: sectionItems, cardType: .Tags, addCardHeader: true, allowEmptyContent: true)
    }
    
    private func getEducationSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: AppStrings.ProfileSectionEducationTitle,
                container: "education",
                containerKey: "name",
                contentType: .Education,
                image: nil
            )
        ]
        return Section(title: AppStrings.ProfileSectionEducationTitle, items: sectionItems, cardType: .Education, addCardHeader: true)
    }
    
    private func getWorkExperienceSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: AppStrings.ProfileSectionExperienceTitle,
                container: "position",
                containerKey: "title",
                contentType: .Position,
                image: nil
            )
        ]
        return Section(title: AppStrings.ProfileSectionExperienceTitle, items: sectionItems, cardType: .Position, addCardHeader: true)
    }
    
    // MARK: - Populate Data
    
    private func populateData() {
        resetCards()
        addPlaceholderCard()
        configureSections()
        // Add top margin only when there is a social connect button added
        // to the profile
        let sectionInsetWithoutHeader = UIEdgeInsetsMake(0.0, 0.0, 1.0, 0.0)
        let sectionInsetWithHeader = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
        var nextSection: Section?
        for (index, section) in enumerate(sections) {
            nextSection = index < (sections.count - 1) ? sections[index + 1] : nil
            let sectionCard = Card(cardType: section.cardType, title: section.title)
            if section.addCardHeader {
                sectionCard.addHeader(
                    headerClass: ProfileSectionHeaderCollectionReusableView.self
                )
            }
            
            // We have to look at the next section, because we currently add
            // the bottom inset for spacing.
            if nextSection?.addCardHeader == true {
                sectionCard.sectionInset = sectionInsetWithHeader
            }
            else {
                sectionCard.sectionInset = sectionInsetWithoutHeader
            }
            
            sectionCard.showContentCount = false
            for item in section.items {
                addItemToCard(item, card: sectionCard)
            }
            
            sectionCard.allowEditingContent = section.allowEmptyContent && isProfileLoggedInUserProfile() && self is CurrentUserProfileDetailDataSource
            if sectionCard.content.count > 0 || sectionCard.allowEditingContent || sectionCard.type == .Placeholder {
                appendCard(sectionCard)
            }
        }
    }
    
    private func addItemToCard(item: SectionItem, card: Card) {
        switch card.type {
        case .Banners:
            addBannerItemToCard(item, card: card)
        case .Education:
            addEducationItemToCard(item, card: card)
        case .Group:
            addGroupItemsToCard(item, card: card)
        case .KeyValue:
            addKeyValueItemToCard(item, card: card)
        case .Tags:
            addTagsItemToCard(item, card: card)
        case .Profiles:
            addOfficeTeamManagerItemToCard(item, card: card)
        case .Position:
            addPositionItemToCard(item, card: card)
        case .QuickActions:
            addQuickActionsItemToCard(item, card: card)
        case .Skills:
            addSkillsItemToCard(item, card: card)
        case .SocialConnectCTAs:
            addSocialConnectItemToCard(item, card: card)
        case .TextValue:
            addAboutItemToCard(item, card: card)
        default: break
        }
    }
    
    private func getValueForItem(item: SectionItem) -> Any? {
        var value: Any? = item.defaultValue
        switch item.container {
        case "profile":
            switch item.containerKey {
            case "hireDate":
                if profile.hasHireDate {
                    value = NSDateFormatter.sharedAnniversaryFormatter.stringFromDate(profile.hireDate.toDate()!)
                }
                else {
                    return nil
                }
                
            case "birthDate":
                if profile.hasBirthDate {
                    value = NSDateFormatter.sharedBirthdayFormatter.stringFromDate(profile.birthDate.toDate()!)
                }
                else {
                    return nil
                }

            default:
                value = profile[item.containerKey]
            }
            
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
        case "groups":
            value = " "
        default:
            break
        }

        return value
    }
    
    private func addGroupItemsToCard(item: SectionItem, card: Card) {
        card.showContentCount = true
        card.contentCount = groups?.count ?? 0

        if let groups = groups {
            if groups.count > 0 {
                card.addContent(content: groups as [AnyObject], maxVisibleItems: numberOfGroupItemsVisibleInitially)
            }
        }
    }
    
    private func addKeyValueItemToCard(item: SectionItem, card: Card) {
        var value = getValueForItem(item)
        if let value = value as? String {
            if value != "" || item.contentType == ContentType.ContactPreferences {
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
    }
    
    private func addTagsItemToCard(item: SectionItem, card: Card) {
        if let interests = interests {
            if interests.count > 0 {
                card.addContent(content: interests as [AnyObject], maxVisibleItems: numberOfTagItemsVisibleInitially)
                if interests.count > numberOfTagItemsVisibleInitially {
                    card.addDefaultFooter()
                }
            }
        }
    }
    
    private func addSkillsItemToCard(item: SectionItem, card: Card) {
        if let skills = skills {
            if skills.count > 0 {
                card.addContent(content: skills as [AnyObject], maxVisibleItems: numberOfSkillItemsVisibleInitially)
                if skills.count > numberOfSkillItemsVisibleInitially {
                    card.addDefaultFooter()
                }
            }
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
    
    private func addEducationItemToCard(item: SectionItem, card: Card) {
        if let resume = resume {
            card.addContent(content: resume.educations as [AnyObject], maxVisibleItems: numberOfEducationItemsVisibleInitially)
            if resume.educations.count > numberOfEducationItemsVisibleInitially {
                card.addDefaultFooter()
            }
        }
    }
    
    private func addPositionItemToCard(item: SectionItem, card: Card) {
        if let resume = resume {
            card.addContent(content: resume.positions as [AnyObject], maxVisibleItems: numberOfExperienceItemsVisibleInitially)
            if resume.positions.count > numberOfExperienceItemsVisibleInitially {
                card.addDefaultFooter()
            }
        }
    }
    
    private func addBannerItemToCard(item: SectionItem, card: Card) {
        if let addBanner = addBannerOfType {
            var bannerDictionary: [String: AnyObject] = [
                "type": addBanner.rawValue,
                "profile": profile
            ]
            
            card.addContent(content: [bannerDictionary])
        }
    }
    
    private func addOfficeTeamManagerItemToCard(item: SectionItem, card: Card) {
        var content = [AnyObject]()
        
        switch item.contentType! {
        case .OfficeTeam:
            if let office = location {
                content.append(office)
            }

        case .Manager:
            if let manager = manager {
                if manager.hasFirstName {
                    content.append(manager)
                }
            }
            
            if let team = team {
                content.append(team)
            }
            
        default:
            break
        }
        
        if content.count > 0 {
            card.addContent(content: content, maxVisibleItems: 0)
        }
    }
    
    private func addQuickActionsItemToCard(item: SectionItem, card: Card) {
        card.addContent(content: [["profile": profile]], maxVisibleItems: 0)
    }
    
    private func addAboutItemToCard(item: SectionItem, card: Card) {
        if profile.hasAbout {
            card.addContent(content: [profile.about] as [AnyObject])
        }
        else {
            // TODO: Remove after testing UI
            let fakeBio = NSString(
                format: "Hi! I'm %@. I work on the %@ team in %@.",
                profile.firstName,
                team!.name,
                location!.address.officeName()
            )
            card.addContent(content: [fakeBio] as [AnyObject])
        }
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is QuickActionsCollectionViewCell {
            let quickActionsCell = cell as! QuickActionsCollectionViewCell
            quickActionsCell.backgroundColor = UIColor.whiteColor()
            quickActionsCell.quickActions = [.Phone, .Message, .Email, .MoreInfo]
        }
    }
    
    // MARK: - Cell Type
    
    func typeOfCell(indexPath: NSIndexPath) -> ContentType {
        let card = cards[indexPath.section]
        if let rowDataDictionary = card.content[indexPath.row] as? [String: AnyObject] {
           return ContentType(rawValue: (rowDataDictionary["type"] as! Int!))!
        }
        
        return .Other
    }

    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if let profileHeader = header as? ProfileHeaderCollectionReusableView {
            profileHeader.setProfile(profile!)
            profileHeaderView = profileHeader
        }
    }
    
    override func configureFooter(footer: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureFooter(footer, atIndexPath: indexPath)
        (footer as! CardFooterCollectionReusableView).insetEdges = false
    }

    private func isProfileLoggedInUserProfile() -> Bool {
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            return loggedInUserProfile.id == profile.id
        }
        
        return false
    }
}
