//
//  LocationAnnotation.swift
//  Circle
//
//  Created by Ravi Rani on 1/10/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {

    class var annotationViewReuseIdentifier: String {
        return "LocationAnnotation"
    }

    private(set) var coordinate: CLLocationCoordinate2D
    private(set) var title: String
    
    required init(coordinate withCoordinate: CLLocationCoordinate2D, title andTitle: String) {
        coordinate = withCoordinate
        title = andTitle
    }
}
