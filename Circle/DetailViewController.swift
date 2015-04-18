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

    private(set) var activityIndicatorView: CircleActivityIndicatorView!
    private(set) var collectionView: UICollectionView!
    private(set) var errorMessageView: CircleErrorMessageView!

    var animationSourceRect: CGRect?
    var dataSource: CardDataSource!
    var delegate: CardCollectionViewDelegate!
    var layout: UICollectionViewFlowLayout!
    
    override func loadView() {
        var rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.opaque = true
        view = rootView
        
        if layout == nil {
            layout = initializeCollectionViewLayout()
        }
        collectionView = initializeCollectionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureActivityIndicator()
        configureErrorMessageView()
        loadData()
    }
    
    final func loadData() {
        dataSource.loadData { (error) -> Void in
            self.activityIndicatorView.stopAnimating()
            if error == nil {
                self.errorMessageView.hide()
                self.collectionView.reloadData()
            }
            else if self.dataSource.cards.count <= 1 {
                self.errorMessageView.error = error
                self.errorMessageView.show()
            }
        }
    }

    // MARK: - Initialization
    
    func initializeCollectionViewLayout() -> StickyHeaderCollectionViewLayout {
        return StickyHeaderCollectionViewLayout()
    }
    
    func initializeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        return collectionView
    }
    
    // MARK: - Configuration
    
    /**
        Configures the collection view for the details - specifically sets the correct
        background color, registers the header, sets the collection view delegate.
    
        Subclasses must override this to actually set the data source and the delegate. So, 
        any custom implmentation should preceed the superstatic function call.
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
        (collectionView.delegate as! CardCollectionViewDelegate).delegate = self
    }
    
    private func configureActivityIndicator() {
        activityIndicatorView = view.addActivityIndicator()
    }
    
    private func configureErrorMessageView() {
        errorMessageView = view.addErrorMessageView(nil, tryAgainHandler: { () -> Void in
            self.errorMessageView.hide()
            self.activityIndicatorView.startAnimating()
            self.loadData()
        })
    }

    // MARK: - Orientation change
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

