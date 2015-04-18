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
    var selectedOffice: Services.Organization.Containers.LocationV1!

    private(set) var addressContainerView: UIView!
    private(set) var closeButton: UIButton!
    private(set) var mapView: MKMapView!

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
        configureAddressView()
        let annotationTitle = NSString(
            format: NSLocalizedString("%@ Office",
                comment: "Title of map annotation indicating the name of the office at a location. E.g., San Francisco Office"),
            selectedOffice.address.city
        )
        
        mapView.annotateAndSetRegion(
            annotationTitle,
            latitude: selectedOffice.address.latitude,
            longitude: selectedOffice.address.longitude
        )
    }

    override func loadView() {
        var rootView = UIView(frame: UIScreen.mainScreen().bounds)
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
        closeButton.setImage(UIImage(named: "Close")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        closeButton.tintColor = UIColor.whiteColor()
        closeButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        closeButton.layer.cornerRadius = 18.0
        closeButton.addTarget(self, action: "close:", forControlEvents: .TouchUpInside)
        view.addSubview(closeButton)
        closeButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)
        closeButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 20.0)
        closeButton.autoSetDimension(.Height, toSize: 36.0)
        closeButton.autoSetDimension(.Width, toSize: 36.0)
        
        // Address View
        addressContainerView = UIView(frame: CGRectMake(0.0, 0.0, view.frameWidth, 35.0))
        addressSnapshotView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        addressContainerView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        view.addSubview(addressContainerView)
        addressContainerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        addressContainerView.autoSetDimension(.Height, toSize: 60.0)
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "close:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        addressContainerView.addGestureRecognizer(tapGestureRecognizer)
        
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "close:")
        addressContainerView.addGestureRecognizer(panGestureRecognizer)
    }

    // MARK: - Configuration
    
    private func configureAddressView() {
        if let addressView = addressSnapshotView {
            addressContainerView.addSubview(addressView)
            addressView.setTranslatesAutoresizingMaskIntoConstraints(false)
            addressView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        }
        else {
            let addressLabel = UILabel(forAutoLayout: ())
            addressLabel.text = selectedOffice.address.fullAddress()
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
    
    // MARK: - Animators
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MapViewAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MapViewAnimator()
    }
    
    func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
