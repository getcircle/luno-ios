//
//  PostDetailViewController.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-08.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class PostDetailViewController: DetailViewController {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        dataSource = PostDetailDataSource()
        delegate = CardCollectionViewDelegate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: track page view
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        
        super.configureCollectionView()
    }
}
