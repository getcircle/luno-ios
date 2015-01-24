//
//  MKMapViewExtension.swift
//  Circle
//
//  Created by Ravi Rani on 1/23/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {

    func annotateAndSetRegion(annotationTitle: String, latitude: String, longitude: String) {
        // Lat/Long coordinates
        let coordinates = CLLocationCoordinate2DMake((latitude as NSString).doubleValue, (longitude as NSString).doubleValue)
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let mapRegion = MKCoordinateRegionMake(coordinates, span)
        setRegion(mapRegion, animated: true)
        addAnnotation(LocationAnnotation(
            coordinate: coordinates,
            title: annotationTitle
        ))
    }
}