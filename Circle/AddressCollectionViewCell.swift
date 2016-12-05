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

    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var cityStateLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.tintColor = UIColor.appSectionHeaderTextColor()
            iconImageView.makeItCircular(true, borderColor: UIColor.appIconBorderColor())
        }
    }
    @IBOutlet private weak var mapView: MKMapView!
    
    override class var classReuseIdentifier: String {
        return "AddressCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 212.0;
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // We want the cell to be selected if the map is tapped.
        return self
    }
    
    // MARK: - Data
    
    override func setData(data: AnyObject) {
        if let office = data as? Services.Organization.Containers.LocationV1 {
            addressLabel.text = office.shortLocationsAddress()
            cityStateLabel.text = office.cityRegionPostalCode()
            
            // Remove annotations that aren't for this office.
            let coordinate = mapView.coordinatesFromLatitudeAndLongitudeStrings(latitude: office.latitude, longitude: office.longitude)
            mapView.removeAnnotations(mapView.annotations.filter {
                let isOffice = ($0.coordinate.latitude == coordinate.latitude && $0.coordinate.longitude == coordinate.longitude)
                return !isOffice
                })
            
            // Add an annotation if there isn't one on the map.
            if mapView.annotations.count == 0 {
                mapView.annotateAndSetRegion(office.name, latitude: office.latitude, longitude: office.longitude)
            }
        }
    }
}
