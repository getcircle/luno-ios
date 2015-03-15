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

    var onlyShowContactInfo = false
    var profile: ProfileService.Containers.Profile!
    var profileHeaderView: ProfileHeaderCollectionReusableView?    

    internal var sections = [Section]()
    
    private(set) var address: OrganizationService.Containers.Address?
    private(set) var identities: Array<UserService.Containers.Identity>?
    private(set) var location: OrganizationService.Containers.Location?
    private(set) var manager: ProfileService.Containers.Profile?
    private(set) var skills: Array<ProfileService.Containers.Skill>?
    private(set) var team: OrganizationService.Containers.Team?
    private(set) var resume: ResumeService.Containers.Resume?

    private let numberOfEducationItemsVisibleInitially = 1
    private let numberOfExperienceItemsVisibleInitially = 2
    private let numberOfSkillItemsVisibleInitially = 6
    
    convenience init(profile withProfile: ProfileService.Containers.Profile) {
        self.init()
        profile = withProfile
    }
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()

        if onlyShowContactInfo == true {
            populateData()
            completionHandler(error: nil)
        }
        else {
            // Add placeholder card to load profile header instantly
            var placeholderCard = Card(cardType: .Placeholder, title: "Info")
            placeholderCard.addHeader(
                headerClass: ProfileHeaderCollectionReusableView.self, 
                headerClassName: "ProfileHeaderCollectionReusableView"
            )
            placeholderCard.sectionInset = UIEdgeInsetsZero
            appendCard(placeholderCard)
            ProfileService.Actions.getExtendedProfile(profile.id) {
                (profile, manager, team, address, skills, _, identities, resume, location, error) -> Void in
                if error == nil {
                    self.manager = manager
                    self.team = team
                    self.address = address
                    self.skills = skills
                    self.identities = identities
                    self.resume = resume
                    self.location = location
                    self.populateData()
                }
                completionHandler(error: error)
            }
        }
    }
    
    // MARK: - Configuration
    
    internal func configureSections() {
        sections.removeAll(keepCapacity: true)
        if onlyShowContactInfo {
            sections.append(getContactInfoSection())
        }
        else {
            sections.append(getQuickActionsSection())
            sections.append(getAboutSection())
            sections.append(getSkillsSection())
            sections.append(getManagerSection())
            sections.append(getOfficeTeamSection())
            sections.append(getBasicInfoSection())
            sections.append(getWorkExperienceSection())
            sections.append(getEducationSection())
        }
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
    
    private func getAboutSection() -> Section {
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
                title: "Seating Info",
                container: "profile",
                containerKey: "seating_info",
                contentType: .SeatingInfo,
                image: nil
            ),
            SectionItem(
                title: "Hire Date",
                container: "profile",
                containerKey: "hire_date",
                contentType: .HireDate,
                image: nil
            ),
            SectionItem(
                title: "Birthday",
                container: "profile",
                containerKey: "birth_date",
                contentType: .Birthday,
                image: nil
            )
        ]
        return Section(title: AppStrings.ProfileSectionInfoTitle, items: sectionItems, cardType: .KeyValue, addCardHeader: true)
    }
    
    private func getContactInfoSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "Email",
                container: "profile",
                containerKey: "email",
                contentType: .Email,
                image: nil
            ),
            SectionItem(
                title: "Cell Phone",
                container: "profile",
                containerKey: "cell_phone",
                contentType: .CellPhone,
                image: nil
            ),
            SectionItem(
                title: "Work Phone",
                container: "profile",
                containerKey: "work_phone",
                contentType: .WorkPhone,
                image: nil
            )
        ]
        return Section(title: "Info", items: sectionItems, cardType: .KeyValue)
    }
    
    func heightOfContactInfoSection() -> CGFloat {
        var height: CGFloat = 0.0
        let contactsSection = getContactInfoSection()
        for item in contactsSection.items {
            if let value = getValueForItem(item) as? String {
                if value != "" {
                    height += KeyValueCollectionViewCell.height
                }
            }
        }

        return height
    }

    private func getOfficeTeamSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: AppStrings.ProfileSectionOfficeTitle,
                container: "",
                containerKey: "",
                contentType: .OfficeTeam,
                image: ItemImage.genericNextImage
            )
        ]
        return Section(title: AppStrings.ProfileSectionOfficeTitle, items: sectionItems, cardType: .Profiles, addCardHeader: true)
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
                title: "Skills",
                container: "skills",
                containerKey: "name",
                contentType: .Skills,
                image: nil
            )
        ]
        
        return Section(title: AppStrings.ProfileSectionSkillsTitle, items: sectionItems, cardType: .Skills, addCardHeader: true, allowEmptyContent: true)
    }
    
    private func getEducationSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: "Education",
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
                title: "Experience",
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

        configureSections()
        // Add top margin only when there is a social connect button added
        // to the profile
        let sectionInsetBeforeBio = UIEdgeInsetsMake(0.0, 0.0, 1.0, 0.0)
        let sectionInsetAfterBio = UIEdgeInsetsMake(0.0, 0.0, 25.0, 0.0)
        var defaultSectionInset = sectionInsetBeforeBio
        for section in sections {
            let sectionCard = Card(cardType: section.cardType, title: section.title)
            if section.addCardHeader {
                sectionCard.addHeader(
                    headerClass: ProfileSectionHeaderCollectionReusableView.self, 
                    headerClassName: "ProfileSectionHeaderCollectionReusableView"
                )
            }
            
            sectionCard.showContentCount = false
            sectionCard.sectionInset = defaultSectionInset

            for item in section.items {
                if item.contentType.rawValue == ContentType.About.rawValue {
                    defaultSectionInset = sectionInsetAfterBio
                    sectionCard.sectionInset = defaultSectionInset
                }

                addItemToCard(item, card: sectionCard)
            }
            
            if sectionCard.content.count > 0 ||
                (section.allowEmptyContent && isProfileLoggedInUserProfile()) {
                appendCard(sectionCard)
            }
        }
    }
    
    private func addItemToCard(item: SectionItem, card: Card) {
        switch card.type {
        case .Education:
            addEducationItemToCard(item, card: card)
        case .KeyValue:
            addKeyValueItemToCard(item, card: card)
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
            case "hire_date":
                if profile.hasHireDate {
                    value = NSDateFormatter.sharedAnniversaryFormatter.stringFromDate(profile.hire_date.toDate()!)
                }
                else {
                    return nil
                }
                
            case "birth_date":
                if profile.hasBirthDate {
                    value = NSDateFormatter.sharedBirthdayFormatter.stringFromDate(profile.birth_date.toDate()!)
                }
                else {
                    return nil
                }
                
            case "seating_info":
                let sampleInfo = [
                    "Floor 1",
                    "Green 4",
                    "Red 15",
                    "R123",
                    "Floor 5",
                    "Floor 10"
                ]
                value = sampleInfo[Int(arc4random_uniform(UInt32(sampleInfo.count)))]
                
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
        default:
            break
        }

        return value
    }
    
    private func addKeyValueItemToCard(item: SectionItem, card: Card) {
        var value = getValueForItem(item)
        if let value = value as? String {
            if value != "" {
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
                format: "Hi! I'm %@. I work on the %@ team in %@. I am a food lover, photographer and traveler.",
                profile.first_name,
                team!.name,
                location!.address.officeName()
            )
            card.addContent(content: [fakeBio] as [AnyObject])
        }
    }
    
    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is QuickActionsCollectionViewCell {
            let quickActionsCell = cell as QuickActionsCollectionViewCell
            quickActionsCell.backgroundColor = UIColor.whiteColor()
            quickActionsCell.quickActions = [.Phone, .Message, .Email, .MoreInfo]
            quickActionsCell.hideLabels()
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

    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if let profileHeader = header as? ProfileHeaderCollectionReusableView {
            profileHeader.setProfile(profile!)
            profileHeaderView = profileHeader
        }
    }
    
    override func configureFooter(footer: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureFooter(footer, atIndexPath: indexPath)
        (footer as CardFooterCollectionReusableView).insetEdges = false
    }

    private func isProfileLoggedInUserProfile() -> Bool {
        if let loggedInUserProfile = AuthViewController.getLoggedInUserProfile() {
            return loggedInUserProfile.id == profile.id
        }
        
        return false
    }
}
