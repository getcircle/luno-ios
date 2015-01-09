//
//  LocationDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/9/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class LocationDetailViewController: DetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
}
