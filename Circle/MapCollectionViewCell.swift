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

    @IBOutlet weak private(set) var blurViewContainer: UIView!
    @IBOutlet weak private(set) var addressLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "MapCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 200.0
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
            frame: contentView.frame,
            andTilesource: source,
            centerCoordinate: coordinates,
            zoomLevel: 10.0,
            maxZoomLevel: 19.0,
            minZoomLevel: 1.0,
            backgroundImage: nil
        )
        mapboxView.setZoom(15.0, animated: true)
        contentView.addSubview(mapboxView)
        contentView.sendSubviewToBack(mapboxView)
        mapboxView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    private func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .Dark)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        visualEffectView.frame = blurViewContainer.frame
        blurViewContainer.addSubview(visualEffectView)
        visualEffectView.alpha = 0.8
        visualEffectView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        
    }
    
    override func setData(data: AnyObject) {
        
    }
}
