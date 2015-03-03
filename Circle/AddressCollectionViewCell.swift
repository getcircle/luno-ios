//
//  AddressCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 3/2/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MapKit
import ProtobufRegistry

class AddressCollectionViewCell: CircleCollectionViewCell {

    @IBOutlet weak private(set) var addressLabel: UILabel!
    @IBOutlet weak private(set) var mapView: MKMapView!
    
    override class var classReuseIdentifier: String {
        return "AddressCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 100.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureMapView()
    }
    
    // MARK: - Configuration
    
    private func configureMapView() {
        mapView.makeItCircular()
        mapView.userInteractionEnabled = false
    }
    
    // MARK: - Data
    
    override func setData(data: AnyObject) {
        if let office = data as? OrganizationService.Containers.Address {
            addressLabel.text = office.shortOfficeAddress()

            // Remove existing annotations
            mapView.removeAnnotations(mapView.annotations)
            mapView.annotateAndSetRegion(
                MapHeaderCollectionReusableView.annotationTitleForLocation(office),
                latitude: office.latitude,
                longitude: office.longitude
            )
        }
    }
}
