//
//  CurrentUserProfileDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 3/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class CurrentUserProfileDetailDataSource: ProfileDetailDataSource {

    override func configureSections() {
        super.configureSections()
        
        if !onlyShowContactInfo {
            sections.removeAtIndex(0)
//            sections.insert(getContactPreferencesSection(), atIndex: 0)
            if let socialConnectSection = getSocialConnectSection() {
                sections.insert(socialConnectSection, atIndex: 0)
            }
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
                            title: AppStrings.SocialConnectLinkedInCTA.uppercaseStringWithLocale(NSLocale.currentLocale()),
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
    
    private func getContactPreferencesSection() -> Section {
        var contactPreferencesSectionItem = SectionItem(
            title: AppStrings.ProfileSectionContactPreferencesTitle,
            container: "", 
            containerKey: "", 
            contentType: .ContactPreferences, 
            image: ItemImage.genericNextImage,
            defaultValue: ""
        )
        
        return Section(title: "", items: [contactPreferencesSectionItem], cardType: .KeyValue)
    }
    
    override func getAboutSection() -> Section {
        var aboutSection = super.getAboutSection()
        aboutSection.addCardHeader = true
        aboutSection.allowEmptyContent = true
        return aboutSection
    }
    
    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if sections.count > 0 && (indexPath.section - 1) >= 0 {
            if (sections[indexPath.section - 1].allowEmptyContent) {
                if let headerView = header as? ProfileSectionHeaderCollectionReusableView {
                    headerView.showAddEditButton = true
                }
            }
        }
    }
}
