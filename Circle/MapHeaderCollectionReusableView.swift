//
//  MapHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/6/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MapKit

class MapHeaderCollectionReusableView: CircleCollectionReusableView, MKMapViewDelegate {

    override class var classReuseIdentifier: String {
        return "MapHeaderCollectionReusableView"
    }
    
    override class var height: CGFloat {
        return 235.0
    }
    
    @IBOutlet weak private(set) var addressLabel: UILabel!
    @IBOutlet weak private(set) var addressContainerView: UIView!
    @IBOutlet weak private(set) var overlayButton: UIButton!
    @IBOutlet weak private(set) var mapView: MKMapView!
    
    private var visualEffectView: UIVisualEffectView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureMapView()
        configureBlurView()
    }
    
    private func configureMapView() {
        // Lat/Long coordinates
        let coordinates = CLLocationCoordinate2DMake(37.782, -122.4055)
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let mapRegion = MKCoordinateRegionMake(coordinates, span)
        mapView.setRegion(mapRegion, animated: true)
        mapView.delegate = self
        
        mapView.addAnnotation(LocationAnnotation(
            coordinate: coordinates,
            title: "San Francisco Office"
        ))
        
        let coordinates1 = CLLocationCoordinate2DMake(36.155034, -86.782300)
        mapView.addAnnotation(LocationAnnotation(
            coordinate: coordinates1,
            title: "Nashville Office"
        ))
        
        let coordinates2 = CLLocationCoordinate2DMake(51.529881, -0.120071)
        mapView.addAnnotation(LocationAnnotation(
            coordinate: coordinates2,
            title: "London Office"
        ))        
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
}
