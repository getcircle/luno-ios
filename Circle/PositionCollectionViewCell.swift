//
//  PositionCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class PositionCollectionViewCell: CircleCollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var companyLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var durationLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var durationLabelBottomConstraint: NSLayoutConstraint!
    
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func intrinsicContentSize() -> CGSize {
        var height = CGFloat()
        for label in [titleLabel, companyLabel, durationLabel] {
            height += label.intrinsicContentSize().height
            if label.text != "" {
                switch label {
                case titleLabel:
                    height += titleLabelTopConstraint.constant
                case companyLabel:
                    height += companyLabelTopConstraint.constant
                case durationLabel:
                    height += durationLabelTopConstraint.constant
                    height += durationLabelBottomConstraint.constant
                default:
                    break
                }
            }
        }
        return CGSizeMake(self.dynamicType.width, height)
    }
    
    override func setData(data: AnyObject) {
        if let position = data as? ResumeService.Containers.Position {
            titleLabel.text = position.title
            companyLabel.text = position.company.name
            durationLabel.text = getFormattedDurationLabel(position)
        }
    }
    
    // MARK: - Formatting
    
    private func getFormattedDurationLabel(position: ResumeService.Containers.Position) -> String {
        return "\(position.start_date.year) - \(position.end_date.year)"
    }

}
