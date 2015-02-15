//
//  SkillsOverviewDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class SkillsOverviewDataSource: NSObject, UICollectionViewDataSource {

    private var filteredSkills = Array<Array<ProfileService.Containers.Skill>>()
    private var skills = Array<ProfileService.Containers.Skill>()
    
    private var animatedCell = [NSIndexPath: Bool]()

    // MARK: - Set Initial Data
    
    func setInitialData(#content: [AnyObject]) {
        skills = content as Array<ProfileService.Containers.Skill>
        filteredSkills = sortAlphabeticallyAndArrangeInSections(skills)
    }
    
    func skill(collectionView _: UICollectionView, atIndexPath indexPath: NSIndexPath) -> ProfileService.Containers.Skill? {
        if let skillsSection = filteredSkills[indexPath.section] as Array<ProfileService.Containers.Skill>? {
            if let skill = skillsSection[indexPath.row] as ProfileService.Containers.Skill? {
                return skill
            }
        }
        
        return nil
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return filteredSkills.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredSkills[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            SkillCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as SkillCollectionViewCell
        
        // Configure the cell
        cell.skillLabel.text = filteredSkills[indexPath.section][indexPath.row].name.capitalizedString
        if animatedCell[indexPath] == nil {
            animatedCell[indexPath] = true
            cell.animateForCollection(collectionView, atIndexPath: indexPath)
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView =  collectionView.dequeueReusableSupplementaryViewOfKind(
                kind, 
                withReuseIdentifier: SearchResultsCardHeaderCollectionReusableView.classReuseIdentifier, 
                forIndexPath: indexPath
            ) as SearchResultsCardHeaderCollectionReusableView
            
            var indexPathOfFirstSkillInSection = NSIndexPath(forItem: 0, inSection: indexPath.section)
            if let skill = skill(collectionView: collectionView, atIndexPath: indexPathOfFirstSkillInSection) {
                headerView.cardTitleLabel.text = skill.name[0].uppercaseString
                headerView.cardTitleLabel.font = UIFont.appSkillsOverviewSectionHeader()
            }
            
            return headerView
        }
        else {
            let footerView =  collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: SeparatorDecorationView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as SeparatorDecorationView
            
            return footerView
        }
    }
    
    // MARK: - Filter
    
    func filterNotes(term: String) {
        if term.trimWhitespace() == "" {
            filteredSkills = sortAlphabeticallyAndArrangeInSections(skills)
            return
        }
        
        let trimmedTerm = term.trimWhitespace()
        let filterTerms = trimmedTerm.componentsSeparatedByString(" ")
        var orPredicates = [NSPredicate]()

        // Full/exact profile name match
        let fullSkillNameMatch = NSComparisonPredicate(
            leftExpression: NSExpression(forVariable: "content"),
            rightExpression: NSExpression(forConstantValue: trimmedTerm),
            modifier: .DirectPredicateModifier,
            type: .BeginsWithPredicateOperatorType,
            options: .CaseInsensitivePredicateOption
        )
        orPredicates.append(fullSkillNameMatch)
        
        for filterTerm in filterTerms {
            let trimmedFilterTerm = filterTerm.trimWhitespace()
            
            // Match begins with
            let beginsWithPredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "content"),
                rightExpression: NSExpression(forConstantValue: trimmedFilterTerm),
                modifier: .DirectPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            
            orPredicates.append(beginsWithPredicate)
            
            // Match each component of content
            let componentMatchPredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "content_components"),
                rightExpression: NSExpression(forConstantValue: trimmedFilterTerm),
                modifier: .AnyPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            orPredicates.append(componentMatchPredicate)
        }
        
        // Apply predicates to notes
        
        let finalPredicate = NSCompoundPredicate.orPredicateWithSubpredicates(orPredicates)
        let filteredSkillsData = skills.filter {
            let match = finalPredicate.evaluateWithObject(
                $0,
                substitutionVariables: [
                    "content": $0.name,
                    "content_components": $0.name.componentsSeparatedByString(" ")
                ]
            )
            
            return match
        }
        
        filteredSkills = sortAlphabeticallyAndArrangeInSections(filteredSkillsData)
    }
    
    // MARK: - Helpers
    
    private func sortAlphabeticallyAndArrangeInSections(skillsArray: Array<ProfileService.Containers.Skill>) -> Array<Array<ProfileService.Containers.Skill>> {
        let sortedSkills = skillsArray.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending }
        
        var skillsArrangedByFirstLetter = Array<Array<ProfileService.Containers.Skill>>()
        var previousLetter = sortedSkills[0].name[0].uppercaseString
        var skillsPerLetter = Array<ProfileService.Containers.Skill>()
        for skill in sortedSkills {
            
            if previousLetter != skill.name[0].uppercaseString {
                skillsArrangedByFirstLetter.append(skillsPerLetter)
                skillsPerLetter.removeAll(keepCapacity: true)
            }
            
            skillsPerLetter.append(skill)
            previousLetter = skill.name[0].uppercaseString
        }
        
        return skillsArrangedByFirstLetter
    }
}