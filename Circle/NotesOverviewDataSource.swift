//
//  NotesOverviewDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 1/28/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class NotesOverviewDataSource: CardDataSource {
    
    private var filteredNotes = Array<NoteService.Containers.Note>()
    private var notes = Array<NoteService.Containers.Note>()
    private var profiles = Dictionary<String, ProfileService.Containers.Profile>()
    
    // MARK: - Set Initial Data
    
    override func setInitialData(#content: [AnyObject], ofType: Card.CardType? = .Profiles, withMetaData metaData:AnyObject? = nil) {
        notes = content as Array<NoteService.Containers.Note>
        filteredNotes = notes
        for profile in metaData as Array<ProfileService.Containers.Profile> {
            profiles[profile.id] = profile
        }
    }
    
    // MARK: - Load Data
    
    override func loadData(completionHandler: (error: NSError?) -> Void) {
        resetCards()

        let notesCard = Card(cardType: .Notes, title: "Notes")
        notesCard.addContent(content: filteredNotes)
        notesCard.metaData = profiles
        notesCard.sectionInset = UIEdgeInsetsMake(1.0, 0.0, 30.0, 0.0)
        appendCard(notesCard)
        completionHandler(error: nil)
    }
    
    func addNote(note: NoteService.Containers.Note, forProfile profile: ProfileService.Containers.Profile) {
        notes.insert(note, atIndex: 0)
        profiles[note.for_profile_id] = profile
    }
    
    func removeNote(noteToBeDeleted: NoteService.Containers.Note, forProfile profile: ProfileService.Containers.Profile) {
        for (index, note) in enumerate(notes) {
            if noteToBeDeleted.id == notes[index].id {
                notes.removeAtIndex(index)
                break
            }
        }
    }
    
    func filterNotes(term: String) {
        if term.trimWhitespace() == "" {
            filteredNotes = notes
            return
        }
        
        let trimmedTerm = term.trimWhitespace()
        let filterTerms = trimmedTerm.componentsSeparatedByString(" ")
        var orPredicates = [NSPredicate]()
        var profileNameOrPredicates = [NSPredicate]()
        
        // Full/exact profile name match
        let fullProfileNameMatch = NSComparisonPredicate(
            leftExpression: NSExpression(forVariable: "profile_name"),
            rightExpression: NSExpression(forConstantValue: trimmedTerm),
            modifier: .DirectPredicateModifier,
            type: .BeginsWithPredicateOperatorType,
            options: .CaseInsensitivePredicateOption
        )
        profileNameOrPredicates.append(fullProfileNameMatch)
        
        for filterTerm in filterTerms {
            let trimmedFilterTerm = filterTerm.trimWhitespace()
            
            // Match begins with for each word
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

            // Match with each component of profile name
            let profileNameComponentMatchPredicate = NSComparisonPredicate(
                leftExpression: NSExpression(forVariable: "profile_name_components"),
                rightExpression: NSExpression(forConstantValue: trimmedFilterTerm),
                modifier: .AnyPredicateModifier,
                type: .BeginsWithPredicateOperatorType,
                options: .CaseInsensitivePredicateOption
            )
            profileNameOrPredicates.append(profileNameComponentMatchPredicate)
        }
        
        // Apply predicates to notes
        
        let finalPredicate = NSCompoundPredicate.orPredicateWithSubpredicates(orPredicates)
        var includedNotesIds = [String: Bool]()
        filteredNotes = notes.filter {
            let match = finalPredicate.evaluateWithObject(
                $0,
                substitutionVariables: [
                    "content": $0.content,
                    "content_components": $0.content.componentsSeparatedByString(" ")
                ]
            )
            
            if match {
                includedNotesIds[$0.id] = true
            }
            
            return match
        }
        
        // Find matching profiles and include those in filtered notes if not already included
        
        let finalProfileNamePredicate = NSCompoundPredicate.orPredicateWithSubpredicates(profileNameOrPredicates)
        var matchedProfileIds = [String: Bool]()
        for (profileId, profile) in profiles {
            let match = finalProfileNamePredicate.evaluateWithObject(profile, substitutionVariables: [
                "profile_name": profile.full_name,
                "profile_name_components": [profile.first_name, profile.last_name]
            ])
            
            if match {
                matchedProfileIds[profileId] = true
            }
        }
        
        for note in notes {
            if matchedProfileIds[note.for_profile_id] == true && includedNotesIds[note.id] == nil {
                filteredNotes.append(note)
            }
        }
    }

    // MARK: - Cell Configuration
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if cell is NotesCollectionViewCell {
            if let note = contentAtIndexPath(indexPath) as? NoteService.Containers.Note {
                (cell as NotesCollectionViewCell).setProfile(profiles[note.for_profile_id]!)
            }
        }
    }
}
