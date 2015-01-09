//
//  LocationDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class LocationDetailViewController: DetailViewController {

    // MARK: - Configuration

    override func configureCollectionView() {
        // Data Source
        dataSource = LocationDetailDataSource()
        collectionView.dataSource = dataSource
        
        // Delegate
        delegate = ProfileCollectionViewDelegate()
        collectionView.delegate = delegate
        
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let profile = dataSource.contentAtIndexPath(indexPath)? as? ProfileService.Containers.Profile {
            var profileVC = ProfileDetailViewController()
            profileVC.profile = profile
            println(profile)
            navigationController?.pushViewController(profileVC, animated: true)
        }

        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
}
