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
        
        Tracker.sharedInstance.trackPageView(
            pageType: .PostDetail,
            pageId: (dataSource as! PostDetailDataSource).post.id
        )
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        super.configureCollectionView()
        collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let dataSource = collectionView.dataSource as? PostDetailDataSource {
            if let card = dataSource.cardAtSection(indexPath.section) {
                switch card.type {
                case .Profiles:
                    let data: AnyObject? = dataSource.contentAtIndexPath(indexPath)
                    if let profile = data as? Services.Profile.Containers.ProfileV1 {
                        showProfileDetail(profile)
                    }
                    
                default:
                    break
                }
            }
        }
    }
    
}
