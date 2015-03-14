//
//  DetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import MessageUI
import UIKit
import ProtobufRegistry

class DetailViewController: BaseDetailViewController, UICollectionViewDelegate {

    private(set) var activityIndicatorView: UIActivityIndicatorView!
    var animationSourceRect: CGRect?
    private(set) var collectionView: UICollectionView!
    var dataSource: CardDataSource!
    var delegate: StickyHeaderCollectionViewDelegate!
    var layout: StickyHeaderCollectionViewLayout!
    
    override func loadView() {
        var rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.opaque = true
        view = rootView
        
        // Collection View
        layout = StickyHeaderCollectionViewLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)

        // Activity View
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.setTranslatesAutoresizingMaskIntoConstraints(true)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.autoCenterInSuperview()
        activityIndicatorView.startAnimating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        dataSource.loadData { (error) -> Void in
            self.activityIndicatorView.stopAnimating()
            self.collectionView!.reloadData()
        }
    }

    // MARK: - Configuration
    
    /**
        Configures the collection view for the details - specifically sets the correct
        background color, registers the header, sets the collection view delegate.
    
        Subclasses must override this to actually set the data source and the delegate. So, 
        any custom implmentation should preceed the superclass function call.
    */
    func configureCollectionView() {
        assert(dataSource != nil, { () -> String in
            return "Data source must be set before calling this function"
        }())
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.showsVerticalScrollIndicator = true
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        (collectionView.delegate as CardCollectionViewDelegate).delegate = self
    }

    // MARK: - Orientation change
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

