//
//  MapCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 1/6/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MapKit

class MapCollectionViewCell: CircleCollectionViewCell {

    override class var classReuseIdentifier: String {
        return "MapCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 120.0
    }
    
    @IBOutlet weak private(set) var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureMapView()
    }
    
    private func configureMapView() {
        mapView.scrollEnabled = false
        mapView.rotateEnabled = false
        mapView.zoomEnabled = false
        
        // Lat/Long coordinates
        let coordinates = CLLocationCoordinate2D(latitude: 37.782, longitude: -122.4055)
        let span = MKCoordinateSpanMake(0.001, 0.01)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    override func setData(data: AnyObject) {
        
    }
}
