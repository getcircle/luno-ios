//
//  NotesCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 1/4/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class NotesCollectionViewCell: CircleCollectionViewCell {
    
    @IBOutlet weak var noteOnProfileName: UILabel!
    @IBOutlet weak var noteSummaryLabel: UILabel!
    @IBOutlet weak var noteTimestampLabel: UILabel!
    @IBOutlet weak var noteTimestampLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    
    override class var classReuseIdentifier: String {
        return "NotesCell"
    }
    
    override class var height: CGFloat {
        return 48.0
    }
    
    override class var lineSpacing: CGFloat {
        return 0.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }

    var showUserProfile: Bool = true {
        didSet {
            if oldValue != showUserProfile {
                adjustConstraintsAsPerProfileVisibility()
            }
        }
    }

    override func intrinsicContentSize() -> CGSize {
        if showUserProfile {
            return CGSizeMake(self.dynamicType.width, 70.0)
        }
        
        return CGSizeMake(self.dynamicType.width, self.dynamicType.height)
    }
    
    override func setData(data: AnyObject) {
        if let note = data as? NoteService.Containers.Note {
            noteSummaryLabel.text = note.content
            if let gmtDate = NSDateFormatter.dateFromTimestampString(note.changed) {
                noteTimestampLabel.text = NSDateFormatter.localizedRelativeDateString(gmtDate)
            }
        }
    }
    
    func setProfile(profile: ProfileService.Containers.Profile) {
        if profile == AuthViewController.getLoggedInUserProfile() {
            noteOnProfileName.text = NSLocalizedString("Your note", comment: "Text indicating that the note is user's private note")
        }
        else {
            noteOnProfileName.text = NSString(format: NSLocalizedString("Note on %@",
                comment: "Title for note on a specific person. E.g., Note on Michael"),
                (profile.first_name + " " + profile.last_name[0] + "."))
        }
    }
    
    private func adjustConstraintsAsPerProfileVisibility() {
        if !showUserProfile {
            noteTimestampLabelTopConstraint.constant = -(noteTimestampLabel.frameY - noteOnProfileName.frameY)

            noteSummaryLabel.setNeedsUpdateConstraints()
            noteTimestampLabel.setNeedsUpdateConstraints()
            separatorView.setNeedsUpdateConstraints()
            noteSummaryLabel.layoutIfNeeded()
            noteTimestampLabel.layoutIfNeeded()
            separatorView.layoutIfNeeded()
            noteOnProfileName.hidden = true
        }
        else {
            // this is the default, so no action is needed
        }
    }
}
