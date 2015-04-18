//
//  MapHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/6/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MapKit
import ProtobufRegistry

class MapHeaderCollectionReusableView: CircleCollectionReusableView, MKMapViewDelegate {

    override class var classReuseIdentifier: String {
        return "MapHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 235.0
    }
    
    @IBOutlet weak private(set) var addressLabel: UILabel!
    @IBOutlet weak private(set) var addressLabelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var addressContainerView: UIView!
    @IBOutlet weak private(set) var addressContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var overlayButton: UIButton!
    @IBOutlet weak private(set) var mapView: MKMapView!
    
    var initialHeightForAddressContainer: CGFloat!
    var allowInteraction: Bool = false {
        didSet {
            overlayButton.hidden = allowInteraction
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        initialHeightForAddressContainer = addressContainerViewHeightConstraint.constant
        mapView.delegate = self
    }

    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }

        var pinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(LocationAnnotation.annotationViewReuseIdentifier) as? MKPinAnnotationView
        if pinAnnotationView == nil {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: LocationAnnotation.annotationViewReuseIdentifier)
            pinAnnotationView!.pinColor = .Red
            pinAnnotationView!.animatesDrop = true
        }
        else {
            pinAnnotationView?.annotation = annotation
        }
        
        return pinAnnotationView
    }
    
    // MARK: - Set data
    
    func setData(office: Services.Organization.Containers.AddressV1) {
        var addressString = ""
        if office.hasAddress1 {
            addressString = office.address_1 + " "
        }

        if office.hasAddress2 {
            addressString += office.address_2
        }
        
        if addressString == "" {
            addressString = office.city + ", " + office.country_code
        }
        
        if addressString != addressLabel.text {
            // Remove existing annotations
            mapView.removeAnnotations(mapView.annotations)
            addressLabel.text = addressString
            mapView.annotateAndSetRegion(
                MapHeaderCollectionReusableView.annotationTitleForLocation(office),
                latitude: office.latitude,
                longitude: office.longitude
            )
        }
    }
    
    func setData(#offices: [Services.Organization.Containers.LocationV1]) {
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Annotate all offices
        for office in offices {
            mapView.addAnnotation(
                MapHeaderCollectionReusableView.annotationTitleForLocation(office.address),
                latitude: office.address.latitude,
                longitude: office.address.longitude
            )
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        // Set address label
        if offices.count == 1 {
            addressLabel.text = NSLocalizedString("1 office worldwide", comment: "Label indicating there is one office worldwide")
        }
        else {
            addressLabel.text = NSString(
                format: NSLocalizedString("%d offices worldwide",
                    comment: "Label indicating there are # offices worldwide. E.g., 3 offices worldwide"),
                offices.count
            )
        }
    }

    class func annotationTitleForLocation(office: Services.Organization.Containers.AddressV1) -> String {
        let annotationTitle = NSString(
            format: NSLocalizedString("%@ Office",
                comment: "Title of map annotation indicating the name of the office at a location. E.g., San Francisco Office"),
            office.city
        )
        
        return annotationTitle
    }
}
