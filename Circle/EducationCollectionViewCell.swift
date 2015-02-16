//
//  EducationCollectionViewCell.swift
//  Circle
//
//  Created by Michael Hahn on 2/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class EducationCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var degreeAndFieldOfStudyLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var schoolNameLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var degreeAndFieldOfStudyLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var durationLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var durationLabelBottomConstraint: NSLayoutConstraint!
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    override func intrinsicContentSize() -> CGSize {
        var height = CGFloat()
        for label in [schoolNameLabel, degreeAndFieldOfStudyLabel, durationLabel] {
            height += label.intrinsicContentSize().height
            if label.text != "" {
                switch label {
                case schoolNameLabel:
                    height += schoolNameLabelTopConstraint.constant
                case degreeAndFieldOfStudyLabel:
                    height += degreeAndFieldOfStudyLabelTopConstraint.constant
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
        if let education = data as? ResumeService.Containers.Education {
            schoolNameLabel.text = education.school_name
            degreeAndFieldOfStudyLabel.text = getFormattedDegreeAndFieldOfStudy(education)
            durationLabel.text = getFormattedDurationLabel(education)
        }
    }
    
    // MARK: - Formatting
    
    private func getFormattedDegreeAndFieldOfStudy(education: ResumeService.Containers.Education) -> String {
        var label = String()
        if education.degree != "" {
            label = "\(education.degree)"
        }
        if education.field_of_study != "" {
            var fieldOfStudy = education.field_of_study
            if label != "" {
                fieldOfStudy = ", \(fieldOfStudy)"
            }
            label += fieldOfStudy
        }
        return label
    }
    
    private func getFormattedDurationLabel(education: ResumeService.Containers.Education) -> String {
        var label = String()
        if education.start_date.year != 0 {
            label = "\(education.start_date.year)"
        }
        if education.end_date.year != 0 {
            var endDate = "\(education.end_date.year)"
            if label != "" {
                endDate = " - \(endDate)"
            }
            label += endDate
        }
        return label
    }
}
