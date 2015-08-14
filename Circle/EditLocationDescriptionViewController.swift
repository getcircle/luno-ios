//
//  EditLocationDescriptionViewController.swift
//  Circle
//
//  Created by Ravi Rani on 8/7/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class EditLocationDescriptionViewController: TextInputViewController {
    
    var location: Services.Organization.Containers.LocationV1!
    
    override func assertRequiredData() {
        assert(location != nil, "Location should be set for this view controller")
    }
    
    override func getData() -> String? {
        if location.hasDescription {
            return location.description_.value.trimWhitespace()
        }
        
        return nil
    }
    
    override func getViewTitle() -> String {
        return "Location Description"
    }
    
    override func getTextPlaceholder() -> String {
        return "Add a description on your location. You can add unique things about the office, what teams work there, and local info about the office."
    }
    
    override func saveData(data: String) {
        let locationBuilder = location.toBuilder()
        let descriptionBuilder: Services.Common.Containers.DescriptionV1Builder
        if let description = locationBuilder.description_ {
            descriptionBuilder = description.toBuilder()
        } else {
            descriptionBuilder = Services.Common.Containers.DescriptionV1.builder()
        }
        descriptionBuilder.value = data
        locationBuilder.description_ = descriptionBuilder.build()
        Services.Organization.Actions.updateLocation(locationBuilder.build()) { (location, error) -> Void in
            self.onDataSaved(location)
        }
    }
}

