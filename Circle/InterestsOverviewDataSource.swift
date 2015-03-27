//
//  InterestsOverviewDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class InterestsOverviewDataSource: NSObject, UICollectionViewDataSource {

    private var filteredInterests = Array<Array<ProfileService.Containers.Tag>>()
    private var interests = Array<ProfileService.Containers.Tag>()
    
    private var animatedCell = [NSIndexPath: Bool]()

    // MARK: - Set Initial Data
    
    func setInitialData(#content: [AnyObject]) {
        interests = content as Array<ProfileService.Containers.Tag>
        filteredInterests = sortAlphabeticallyAndArrangeInSections(interests)
    }
    
    func interest(collectionView _: UICollectionView, atIndexPath indexPath: NSIndexPath) -> ProfileService.Containers.Tag? {
        if let interestsSection = filteredInterests[indexPath.section] as Array<ProfileService.Containers.Tag>? {
            if let interest = interestsSection[indexPath.row] as ProfileService.Containers.Tag? {
                return interest
            }
        }
        
        return nil
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return filteredInterests.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredInterests[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            InterestCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as InterestCollectionViewCell
        
        // Configure the cell
        cell.interestLabel.text = filteredInterests[indexPath.section][indexPath.row].name.capitalizedString
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
            
            var indexPathOfFirstInterestInSection = NSIndexPath(forItem: 0, inSection: indexPath.section)
            if let interest = interest(collectionView: collectionView, atIndexPath: indexPathOfFirstInterestInSection) {
                headerView.cardTitleLabel.text = interest.name[0].uppercaseString
                headerView.cardTitleLabel.font = UIFont.appInterestsOverviewSectionHeader()
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
            filteredInterests = sortAlphabeticallyAndArrangeInSections(interests)
            return
        }
        
        let trimmedTerm = term.trimWhitespace()
        let filterTerms = trimmedTerm.componentsSeparatedByString(" ")
        var orPredicates = [NSPredicate]()

        // Full/exact interest name match
        let fullInterestNameMatch = NSComparisonPredicate(
            leftExpression: NSExpression(forVariable: "content"),
            rightExpression: NSExpression(forConstantValue: trimmedTerm),
            modifier: .DirectPredicateModifier,
            type: .BeginsWithPredicateOperatorType,
            options: .CaseInsensitivePredicateOption
        )
        orPredicates.append(fullInterestNameMatch)
        
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
        let filteredInterestsData = interests.filter {
            let match = finalPredicate.evaluateWithObject(
                $0,
                substitutionVariables: [
                    "content": $0.name,
                    "content_components": $0.name.componentsSeparatedByString(" ")
                ]
            )
            
            return match
        }
        
        filteredInterests = sortAlphabeticallyAndArrangeInSections(filteredInterestsData)
    }
    
    // MARK: - Helpers
    
    private func sortAlphabeticallyAndArrangeInSections(interestsArray: Array<ProfileService.Containers.Tag>) -> Array<Array<ProfileService.Containers.Tag>> {
        let sortedInterests = interestsArray.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending }
        
        var interestsArrangedByFirstLetter = Array<Array<ProfileService.Containers.Tag>>()
        
        if sortedInterests.count > 0 {
            var previousLetter = sortedInterests[0].name[0].uppercaseString
            var interestsPerLetter = Array<ProfileService.Containers.Tag>()
            for interest in sortedInterests {
                
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
