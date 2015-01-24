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
    
    func setData(address: OrganizationService.Containers.Address) {
        var addressString = ""
        if address.hasAddress1 {
            addressString = address.address_1 + " "
        }

        if address.hasAddress2 {
            addressString += address.address_2
        }
        
        if addressString == "" {
            addressString = address.city + ", " + address.country_code
        }
        
        
        let annotationTitle = NSString(
            format: NSLocalizedString("%@ Office",
                comment: "Title of map annotation indicating the name of the office at a location. E.g., San Francisco Office"),
            address.city
        )

        addressLabel.text = addressString
        mapView.annotateAndSetRegion(annotationTitle, latitude: address.latitude, longitude: address.longitude)
    }
}
