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
    
    override class var classReuseIdentifier: String {
        return "EducationCollectionViewCell"
    }
    
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
        if let education = data as? Services.Resume.Containers.EducationV1 {
            schoolNameLabel.text = education.schoolName
            degreeAndFieldOfStudyLabel.text = getFormattedDegreeAndFieldOfStudy(education)
            durationLabel.text = getFormattedDurationLabel(education)
        }
    }
    
    // MARK: - Formatting
    
    private func getFormattedDegreeAndFieldOfStudy(education: Services.Resume.Containers.EducationV1) -> String {
        var label = String()
        if education.degree != "" {
            label = "\(education.degree)"
        }
        if education.fieldOfStudy != "" {
            var fieldOfStudy = education.fieldOfStudy
            if label != "" {
                fieldOfStudy = ", \(fieldOfStudy)"
            }
            label += fieldOfStudy
        }
        return label
    }
    
    private func getFormattedDurationLabel(education: Services.Resume.Containers.EducationV1) -> String {
        var label = String()
        if education.startDate.year != 0 {
            label = "\(education.startDate.year)"
        }
        if education.endDate.year != 0 {
            var endDate = "\(education.endDate.year)"
            if label != "" {
                endDate = " - \(endDate)"
            }
            label += endDate
        }
        return label
    }
}
