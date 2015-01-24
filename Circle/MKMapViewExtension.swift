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
        let coordinates = coordinatesFromLatitudeAndLongitudeStrings(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let mapRegion = MKCoordinateRegionMake(coordinates, span)
        setRegion(mapRegion, animated: true)
        addAnnotation(LocationAnnotation(
            coordinate: coordinates,
            title: annotationTitle
        ))
    }
    
    func addAnnotation(annotationTitle: String, latitude: String, longitude: String) {
        let coordinates = CLLocationCoordinate2DMake((latitude as NSString).doubleValue, (longitude as NSString).doubleValue)
        addAnnotation(LocationAnnotation(
            coordinate: coordinates,
            title: annotationTitle
        ))
    }
    
    func coordinatesFromLatitudeAndLongitudeStrings(#latitude: String, longitude: String) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake((latitude as NSString).doubleValue, (longitude as NSString).doubleValue)
    }
    
    /**
        Finds enclosing region and centers map around it
    */
    func setRegion(coordinates: [CLLocationCoordinate2D]) {
        
        var minLat: Double, minLong: Double, maxLat: Double, maxLong: Double
        var centerLat: Double, centerLong: Double, spanLat: Double, spanLong: Double
        let spanCorrection: Double = 20.0
        
        // Set initial values
        minLat = coordinates.first!.latitude
        maxLat = minLat
        minLong = coordinates.first!.longitude
        maxLong = minLong
        
        // Find min. and max. values
        for coordinate in coordinates {
            minLat = fmin(minLat, coordinate.latitude)
            maxLat = fmax(maxLat, coordinate.latitude)
            minLong = fmin(minLong, coordinate.longitude)
            maxLong = fmax(maxLong, coordinate.longitude)
        }
        
        // Calculate center and span
        centerLat = (minLat + maxLat)/2.0
        centerLong = (minLong + maxLong)/2.0
     
        spanLat = abs(maxLat - minLat)
        spanLong = abs(maxLong - minLong)
        
        
        println("Span = \(spanLat) \(spanLong)")

        let coordinates = CLLocationCoordinate2DMake(centerLat, centerLong)
        let span = MKCoordinateSpanMake(spanLat + spanCorrection, spanLong + spanCorrection)
        let mapRegion = MKCoordinateRegionMake(coordinates, span)
        setRegion(mapRegion, animated: true)
    }
    
    func zoomMapToIncludeAllAnnotations() {
        var zoomRect = MKMapRectNull
        for annotation in annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
            if MKMapRectIsNull(zoomRect) {
                zoomRect = pointRect
            }
            else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect)
            }
        }
        
        zoomRect = mapRectThatFits(zoomRect)
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsZero, animated: true)
    }
}