//
//  NotesCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 1/4/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class NotesCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet private(set) weak var notesLabel: UILabel!
    @IBOutlet private(set) weak var notesTextView: UITextView!
    @IBOutlet private(set) weak var timestampLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "NotesCell"
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }

    override func intrinsicContentSize() -> CGSize {
        let intrinsicSize = notesTextView.intrinsicContentSize()
        let height = intrinsicSize.height + notesTextView.frameY + 10.0
        return CGSizeMake(NotesCollectionViewCell.width, height)
    }
    
    override func setData(data: AnyObject) {
        if let notesDictionary = data as? [String: String] {
            notesTextView.text = notesDictionary["text"]
        }
    }
}
