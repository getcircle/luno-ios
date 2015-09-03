//
//  ContactCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 8/10/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ContactCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var contactImageView: UIImageView!
    @IBOutlet weak private(set) var contactMethodNameLabel: UILabel!
    @IBOutlet weak private(set) var contactMethodValueLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "ContactCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 60.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setData(data: AnyObject) {
        if let contactMethod = data as? Services.Profile.Containers.ContactMethodV1 {
            
            if let imageSource = getImageByType(contactMethod.contactMethodType) {
                contactImageView.image = UIImage(named: imageSource)?.imageWithRenderingMode(.AlwaysTemplate)
                contactImageView.tintColor = contactMethodNameLabel.textColor
            }
            
            contactMethodNameLabel.text = getLabelByType(contactMethod.contactMethodType)
            contactMethodValueLabel.text = contactMethod.value
        }
    }
    
    // MARK: - Helpers
    
    private func getImageByType(contactMethodType: Services.Profile.Containers.ContactMethodV1.ContactMethodTypeV1) -> String? {
        
        switch contactMethodType {
        case .Email:
            return "detail_email"
            
        case .Phone, .CellPhone:
            return "Call"
            
        default:
            return nil
        }
    }

    private func getLabelByType(contactMethodType: Services.Profile.Containers.ContactMethodV1.ContactMethodTypeV1) -> String {
        
        switch contactMethodType {
        case .Email:
            return "Email"
            
        case .Phone, .CellPhone:
            return "Phone"
            
        default:
            return ""
        }
    }
}
