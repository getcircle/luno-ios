//
//  ProfileStatusDetailViewController.swift
//  Luno
//
//  Created by Ravi Rani on 10/14/15.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileStatusDetailViewController: DetailViewController {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()
        
        dataSource = ProfileStatusDetailDataSource()
        delegate = CardCollectionViewDelegate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Tracker.sharedInstance.trackPageView(
            pageType: .ProfileStatusDetail,
            pageId: (dataSource as! ProfileStatusDetailDataSource).profileStatus.id
        )
    }

    override func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        super.configureCollectionView()
    }
    
    override internal func offsetForActivityIndicator() -> CGFloat {
        return 0.0
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let tappedCard = dataSource.cardAtSection(indexPath.section) {
            switch tappedCard.type {
            case .Profiles:
                if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                    showProfileDetail(profile)
                }
                
            default:
                break
            }
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
}
