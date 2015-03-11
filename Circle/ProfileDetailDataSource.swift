//
//  ProfileDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 11/28/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileDetailDataSource: UnderlyingCollectionViewDataSource {

    var onlyShowContactInfo = false
    var profile: ProfileService.Containers.Profile!
    
    private(set) var address: OrganizationService.Containers.Address?
    private(set) var manager: ProfileService.Containers.Profile?
    private(set) var skills: Array<ProfileService.Containers.Skill>?
    private(set) var team: OrganizationService.Containers.Team?
    private(set) var identities: Array<UserService.Containers.Identity>?
    private(set) var resume: ResumeService.Containers.Resume?
    private(set) var location: OrganizationService.Containers.Location?

    private var hasSocialConnectCTAs = false
    private var sections = [Section]()

    private let numberOfEducationItemsVisibleInitially = 1
    private let numberOfExperienceItemsVisibleInitially = 2
    private let numberOfSkillItemsVisibleInitially = 6
    
    convenience init(profile withProfile: ProfileService.Containers.Profile) {
        self.init()
        profile = withProfile
    }
    
    override func registerCardHeader(collectionView: UICollectionView) {
        // TODO should have some like "onLoad" function we can plug into
        configureSections()
        collectionView.registerNib(
            UINib(nibName: "ProfileSectionHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileSectionHeaderCollectionReusableView.classReuseIdentifier
        )
        super.registerCardHeader(collectionView)
    }

    override func loadData(completionHandler: (error: NSError?) -> Void) {
        if onlyShowContactInfo == true {
            configureSections()
            populateData()
            completionHandler(error: nil)
        }
        else {
            // Add placeholder card to load profile header instantly
            var placeholderCard = Card(cardType: .Placeholder, title: "Info")
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
    
    private func configureSections() {
        sections.removeAll(keepCapacity: true)
        if onlyShowContactInfo == true {
            sections.append(getContactInfoSection())
        }
        else {
            if let socialConnectSection = getSocialConnectSection() {
                hasSocialConnectCTAs = true
                sections.insert(socialConnectSection, atIndex: 1)
            }
            else {
                hasSocialConnectCTAs = false
            }
            
            sections.append(getQuickActionsSection())
            sections.append(getAboutSection())
            sections.append(getSkillsSection())
            sections.append(getOfficeTeamSection())
            sections.append(getBasicInfoSection())
            sections.append(getWorkExperienceSection())
            sections.append(getEducationSection())
        }
    }
    
    private func getSocialConnectSection() -> Section? {
        if profile.id == AuthViewController.getLoggedInUserProfile()!.id {
            if let identities = identities {
                var hasLinkedInIdentity = false
                for identity in identities {
                    if identity.provider == UserService.Provider.Linkedin {
                        hasLinkedInIdentity = true
                    }
                }
                if !hasLinkedInIdentity {
                    let sectionItems = [
                        SectionItem(
                            title: NSLocalizedString("Connect with LinkedIn", comment: "Button title for connect with LinkedIn button").uppercaseStringWithLocale(NSLocale.currentLocale()),
                            container: "social",
                            containerKey: "profile",
                            contentType: .LinkedInConnect,
                            image: ItemImage(name: "LinkedIn", tint: UIColor.linkedinColor())
                        )
                    ]
                    return Section(title: "Social", items: sectionItems, cardType: .SocialConnectCTAs)
                }
            }
        }
        return nil
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
        return Section(title: "Info", items: sectionItems, cardType: .KeyValue)
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
    
    private func getOfficeTeamSection() -> Section {
        let sectionItems = [
            SectionItem(
                title: AppStrings.ProfileSectionTitle,
                container: "",
                containerKey: "",
                contentType: .OfficeTeam,
                image: ItemImage.genericNextImage
            )
        ]
        return Section(title: AppStrings.ProfileSectionTitle, items: sectionItems, cardType: .Profiles, cardHeaderSize: CGSizeMake(CircleCollectionViewCell.width, CardHeaderCollectionReusableView.height))
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
        return Section(title: "Skills", items: sectionItems, cardType: .Skills, cardHeaderSize: CGSizeMake(CircleCollectionViewCell.width, CardHeaderCollectionReusableView.height))
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
        return Section(title: "Education", items: sectionItems, cardType: .Education, cardHeaderSize: CGSizeMake(CircleCollectionViewCell.width, CardHeaderCollectionReusableView.height))
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
        return Section(title: "Experience", items: sectionItems, cardType: .Position, cardHeaderSize: CGSizeMake(CircleCollectionViewCell.width, CardHeaderCollectionReusableView.height))
    }
    
    // MARK: - Populate Data
    
    private func populateData() {
        resetCards()
        
        // Add top margin only when there is a social connect button added
        // to the profile
        var defaultSectionInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0)
        for section in sections {
            let sectionCard = Card(cardType: section.cardType, title: section.title)
            sectionCard.sectionInset = defaultSectionInset
            sectionCard.headerSize = section.cardHeaderSize

            for item in section.items {
                addItemToCard(item, card: sectionCard)
            }
            
            if sectionCard.content.count > 0 {
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
            addOfficeTeamItemToCard(item, card: card)
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
    
    private func addOfficeTeamItemToCard(item: SectionItem, card: Card) {
        var content = [AnyObject]()
        if let office = location {
            content.append(office)
        }

        if let team = team {
            content.append(team)
        }
        
        card.addContent(content: content, maxVisibleItems: 0)
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
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            var footerView = addDefaultFooterView(collectionView, atIndexPath: indexPath)
            (footerView as CardFooterCollectionReusableView).insetEdges = false
            return footerView
        }
        else {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: ProfileSectionHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as ProfileSectionHeaderCollectionReusableView
            
            headerView.setCard(cards[indexPath.section])
            return headerView
        }
    }
}
