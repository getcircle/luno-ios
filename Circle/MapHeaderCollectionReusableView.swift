//
//  MapHeaderCollectionReusableView.swift
//  Circle
//
//  Created by Ravi Rani on 1/6/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MapKit

class MapHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak private(set) var blurViewContainer: UIView!
    @IBOutlet weak private(set) var addressLabel: UILabel!
    
    class var classReuseIdentifier: String {
        return "MapHeaderCollectionReusableView"
    }
    
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
        
        // Create a tile source from Mapbox
        let source = RMMapboxSource(mapID: "rrani.kmnghfmf")
        var mapboxView = RMMapView(
            frame: frame,
            andTilesource: source,
            centerCoordinate: coordinates,
            zoomLevel: 10.0,
            maxZoomLevel: 19.0,
            minZoomLevel: 1.0,
            backgroundImage: nil
        )
        
        if mapboxView != nil {
            mapboxView.setZoom(15.0, animated: true)
            addSubview(mapboxView)
            sendSubviewToBack(mapboxView)
            mapboxView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
    }
    
    private func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .Dark)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        visualEffectView.frame = blurViewContainer.frame
        blurViewContainer.addSubview(visualEffectView)
        visualEffectView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        
    }
}
