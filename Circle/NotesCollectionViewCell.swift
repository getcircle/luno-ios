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
    
    @IBOutlet weak var noteSummaryLabel: UILabel!
    @IBOutlet weak var noteTimestampLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "NotesCell"
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }

    override func intrinsicContentSize() -> CGSize {
        let intrinsicSize = noteSummaryLabel.intrinsicContentSize()
        let height = intrinsicSize.height + noteSummaryLabel.frameY + 10.0 + noteTimestampLabel.frameY
        return CGSizeMake(NotesCollectionViewCell.width, height)
    }
    
    override func setData(data: AnyObject) {
        if let note = data as? NoteService.Containers.Note {
            noteSummaryLabel.text = note.content
            noteTimestampLabel.text = note.created
        }
    }
}
