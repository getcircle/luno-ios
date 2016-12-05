//
//  MapViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MapKit
import ProtobufRegistry

class MapViewController: UIViewController, UIViewControllerTransitioningDelegate, MKMapViewDelegate {

    var addressSnapshotView: UIView?
    var finalMapViewRect: CGRect?
    var initialMapViewRect: CGRect?
    var location: Services.Organization.Containers.LocationV1!

    private(set) var addressContainerView: UIView!
    private(set) var closeButton: UIButton!
    private(set) var mapView: MKMapView!

    init() {
        super.init(nibName: nil, bundle: nil)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
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

        configureAddressView()
        Tracker.sharedInstance.trackPageView(pageType: .LocationAddressMap, pageId: location.id)
        let annotationTitle = NSString(
            format: NSLocalizedString("%@ Office",
                comment: "Title of map annotation indicating the name of the office at a location. E.g., San Francisco Office"),
            location.city
        )
        
        mapView.annotateAndSetRegion(
            annotationTitle as String,
            latitude: location.latitude,
            longitude: location.longitude
        )
    }

    override func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.backgroundColor = UIColor.clearColor()
        rootView.opaque = false
        view = rootView

        // Map View        
        mapView = MKMapView(forAutoLayout: ())
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        mapView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        mapView.delegate = self
        
        // Close Button
        closeButton = UIButton(forAutoLayout: ())
        closeButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        closeButton.setImage(UIImage(named: "close")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        closeButton.tintColor = UIColor.whiteColor()
        closeButton.imageEdgeInsets = UIEdgeInsetsMake(-7.0, -7.0, -7.0, -7.0)
        closeButton.layer.cornerRadius = 18.0
        closeButton.addTarget(self, action: "close:", forControlEvents: .TouchUpInside)
        view.addSubview(closeButton)
        closeButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)
        closeButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 20.0)
        closeButton.autoSetDimension(.Height, toSize: 36.0)
        closeButton.autoSetDimension(.Width, toSize: 36.0)
        
        // Address View
        addressContainerView = UIView(frame: CGRectMake(0.0, 0.0, view.frame.width, 35.0))
        addressSnapshotView?.translatesAutoresizingMaskIntoConstraints = false
        addressContainerView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        view.addSubview(addressContainerView)
        addressContainerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        addressContainerView.autoSetDimension(.Height, toSize: 60.0)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "close:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        addressContainerView.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "close:")
        addressContainerView.addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: - Configuration
    
    private func configureAddressView() {
        if let addressView = addressSnapshotView {
            addressContainerView.addSubview(addressView)
            addressView.translatesAutoresizingMaskIntoConstraints = false
            addressView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
        else {
            let addressLabel = UILabel(forAutoLayout: ())
            addressLabel.text = location.fullAddress()
            addressLabel.backgroundColor = UIColor.clearColor()
            addressLabel.font = UIFont.appAttributeValueLabelFont()
            addressLabel.textColor = UIColor.whiteColor()
            addressLabel.textAlignment = .Center
            addressLabel.numberOfLines = 2
            addressContainerView.addSubview(addressLabel)
            addressLabel.autoAlignAxisToSuperviewAxis(.Vertical)
            addressLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
            addressLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
            addressLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 15.0)
        }
    }
        
    func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
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
