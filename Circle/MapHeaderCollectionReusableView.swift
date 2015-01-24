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
    
    private var visualEffectView: UIVisualEffectView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        initialHeightForAddressContainer = addressContainerViewHeightConstraint.constant
        configureBlurView()
        mapView.delegate = self
    }

    private func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .Dark)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        visualEffectView.frame = addressContainerView.frame
        addressContainerView.insertSubview(visualEffectView, belowSubview: addressLabel)
        visualEffectView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
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
    
    func setData(location: OrganizationService.Containers.Address) {
        var addressString = ""
        if location.hasAddress1 {
            addressString = location.address_1 + " "
        }

        if location.hasAddress2 {
            addressString += location.address_2
        }
        
        if addressString == "" {
            addressString = location.city + ", " + location.country_code
        }
        
        
        addressLabel.text = addressString
        mapView.annotateAndSetRegion(
            MapHeaderCollectionReusableView.annotationTitleForLocation(location),
            latitude: location.latitude,
            longitude: location.longitude
        )
    }
    
    func setData(#locations: [OrganizationService.Containers.Address]) {
        var coordinates = [CLLocationCoordinate2D]()

        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Annotate all locations
        for location in locations {
            mapView.addAnnotation(
                MapHeaderCollectionReusableView.annotationTitleForLocation(location),
                latitude: location.latitude,
                longitude: location.longitude
            )
        }
        
        // Set zoom
        mapView.zoomMapToIncludeAllAnnotations()
        
        // Set address label
        if locations.count == 1 {
            addressLabel.text = NSLocalizedString("1 office worldwide", comment: "Label indicating there is one office worldwide")
        }
        else {
            addressLabel.text = NSString(
                format: NSLocalizedString("%d offices worldwide",
                    comment: "Label indicating there are # offices worldwide. E.g., 3 offices worldwide"),
                locations.count
            )
        }
    }

    class func annotationTitleForLocation(location: OrganizationService.Containers.Address) -> String {
        let annotationTitle = NSString(
            format: NSLocalizedString("%@ Office",
                comment: "Title of map annotation indicating the name of the office at a location. E.g., San Francisco Office"),
            location.city
        )
        
        return annotationTitle
    }
}
