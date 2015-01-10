//
//  MapViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var addressSnapshotView: UIView?
    var finalMapViewRect: CGRect?
    var initialMapViewRect: CGRect?

    private(set) var addressContainerView: UIView!
    private(set) var closeButton: UIButton!
    private(set) var mapboxView: RMMapView!

    override init() {
        super.init()
        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        customInit()
    }
    
    private func customInit() {
        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let addressView = addressSnapshotView {
            addressContainerView.addSubview(addressView)
            addressView.setTranslatesAutoresizingMaskIntoConstraints(false)
            addressView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
    }
    
    override func loadView() {
        var rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.backgroundColor = UIColor.clearColor()
        rootView.opaque = false
        view = rootView

        // Map View
        
        // Create a tile source from Mapbox
        let coordinates = CLLocationCoordinate2DMake(37.782, -122.4055)
        let source = RMMapboxSource(mapID: "rrani.kmnghfmf")
        mapboxView = RMMapView(
            frame: view.frame,
            andTilesource: source,
            centerCoordinate: coordinates,
            zoomLevel: 10.0,
            maxZoomLevel: 19.0,
            minZoomLevel: 1.0,
            backgroundImage: nil
        )
        
        if mapboxView != nil {
            mapboxView.setZoom(15.0, animated: true)
            mapboxView.setTranslatesAutoresizingMaskIntoConstraints(false)
            view.addSubview(mapboxView)
            view.sendSubviewToBack(mapboxView)
            mapboxView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
        
        // Close Button
        closeButton = UIButton(forAutoLayout: ())
        closeButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        closeButton.setImage(UIImage(named: "Close")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        closeButton.tintColor = UIColor.whiteColor()
        closeButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        closeButton.layer.cornerRadius = 4.0
        closeButton.addTarget(self, action: "close:", forControlEvents: .TouchUpInside)
        view.addSubview(closeButton)
        closeButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)
        closeButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 20.0)
        closeButton.autoSetDimension(.Height, toSize: 35.0)
        closeButton.autoSetDimension(.Width, toSize: 35.0)
        
        // Address View
        addressContainerView = UIView(frame: CGRectMake(0.0, 0.0, view.frameWidth, 35.0))
        addressSnapshotView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        addressContainerView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        view.addSubview(addressContainerView)
        addressContainerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        addressContainerView.autoSetDimension(.Height, toSize: 35.0)
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "close:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        addressContainerView.addGestureRecognizer(tapGestureRecognizer)
        
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "close:")
        addressContainerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MapViewAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MapViewAnimator()
    }
    
    func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
