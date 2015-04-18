//
//  TagsOverviewDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TagsOverviewDataSource: NSObject, UICollectionViewDataSource {

    private var filteredTags = Array<Array<Services.Profile.Containers.TagV1>>()
    private var interests = Array<Services.Profile.Containers.TagV1>()
    
    private var animatedCell = [NSIndexPath: Bool]()

    // MARK: - Set Initial Data
    
    func setInitialData(#content: [AnyObject]) {
        interests = content as Array<Services.Profile.Containers.TagV1>
        filteredTags = sortAlphabeticallyAndArrangeInSections(interests)
    }
    
    func interest(collectionView _: UICollectionView, atIndexPath indexPath: NSIndexPath) -> Services.Profile.Containers.TagV1? {
        if let interestsSection = filteredTags[indexPath.section] as Array<Services.Profile.Containers.TagV1>? {
            if let interest = interestsSection[indexPath.row] as Services.Profile.Containers.TagV1? {
                return interest
            }
        }
        
        return nil
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return filteredTags.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTags[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TagCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as TagCollectionViewCell
        
        // Configure the cell
        cell.interestLabel.text = filteredTags[indexPath.section][indexPath.row].name.capitalizedString
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
                withReuseIdentifier: ProfileSectionHeaderCollectionReusableView.classReuseIdentifier,
                forIndexPath: indexPath
            ) as ProfileSectionHeaderCollectionReusableView
            
            var indexPathOfFirstTagInSection = NSIndexPath(forItem: 0, inSection: indexPath.section)
            if let interest = interest(collectionView: collectionView, atIndexPath: indexPathOfFirstTagInSection) {
                headerView.cardTitleLabel.text = interest.name[0].uppercaseString
                headerView.cardTitleLabel.font = UIFont.appTagsOverviewSectionHeader()
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
    
    func filterData(term: String) {
        if term.trimWhitespace() == "" {
            filteredTags = sortAlphabeticallyAndArrangeInSections(interests)
            return
        }
        
        let trimmedTerm = term.trimWhitespace()
        let filterTerms = trimmedTerm.componentsSeparatedByString(" ")
        var orPredicates = [NSPredicate]()

        // Full/exact interest name match
        let fullTagNameMatch = NSComparisonPredicate(
            leftExpression: NSExpression(forVariable: "content"),
            rightExpression: NSExpression(forConstantValue: trimmedTerm),
            modifier: .DirectPredicateModifier,
            type: .BeginsWithPredicateOperatorType,
            options: .CaseInsensitivePredicateOption
        )
        orPredicates.append(fullTagNameMatch)
        
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
        
        // Apply predicates
        
        let finalPredicate = NSCompoundPredicate.orPredicateWithSubpredicates(orPredicates)
        let filteredTagsData = interests.filter {
            let match = finalPredicate.evaluateWithObject(
                $0,
                substitutionVariables: [
                    "content": $0.name,
                    "content_components": $0.name.componentsSeparatedByString(" ")
                ]
            )
            
            return match
        }
        
        filteredTags = sortAlphabeticallyAndArrangeInSections(filteredTagsData)
    }
    
    // MARK: - Helpers
    
    private func sortAlphabeticallyAndArrangeInSections(interestsArray: Array<Services.Profile.Containers.TagV1>) -> Array<Array<ProfileService.Containers.Tag>> {
        let sortedTags = interestsArray.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending }
        
        var interestsArrangedByFirstLetter = Array<Array<Services.Profile.Containers.TagV1>>()
        
        if sortedTags.count > 0 {
            var previousLetter = sortedTags[0].name[0].uppercaseString
            var interestsPerLetter = Array<Services.Profile.Containers.TagV1>()
            for interest in sortedTags {
                
                if previousLetter != interest.name[0].uppercaseString {
                    interestsArrangedByFirstLetter.append(interestsPerLetter)
                    interestsPerLetter.removeAll(keepCapacity: true)
                }
                
                interestsPerLetter.append(interest)
                previousLetter = interest.name[0].uppercaseString
            }
            
            if interestsPerLetter.count > 0 {
                interestsArrangedByFirstLetter.append(interestsPerLetter)
            }
        }
        return interestsArrangedByFirstLetter
    }
}
