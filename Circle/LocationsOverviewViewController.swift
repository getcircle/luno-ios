//
//  LocationsOverviewViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/24/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class LocationsOverviewViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak private(set) var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    private(set) var dataSource = LocationsOverviewDataSource()
    private(set) var delegate = LocationsOverviewCollectionViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        configureCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.loadData { (error) -> Void in
            if error == nil {
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        (collectionView.delegate as CardCollectionViewDelegate).delegate = self
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        dataSource.registerCardHeader(collectionView)
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let location = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Address {
            
            var locationDetailVC = LocationDetailViewController()
            (locationDetailVC.dataSource as LocationDetailDataSource).selectedLocation = location
            navigationController?.pushViewController(locationDetailVC, animated: true)
        }
    }
}
