//
//  ProfileDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileDetailViewController: DetailViewController {

    var profile: ProfileService.Containers.Profile!

    override func viewDidLoad() {
        (dataSource as ProfileDetailDataSource).profile = profile
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configuration
    override func configureCollectionView() {
        // Data Source
        dataSource = ProfileDetailDataSource()
        collectionView.dataSource = dataSource

        // Delegate
        delegate = ProfileCollectionViewDelegate()
        collectionView.delegate = delegate
        
        super.configureCollectionView()
    }

    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dataSource = collectionView.dataSource as ProfileDetailDataSource
        switch dataSource.typeOfCell(indexPath) {
        case .Manager:
            let profileVC = ProfileDetailViewController()
            profileVC.profile = dataSource.manager
            navigationController?.pushViewController(profileVC, animated: true)

        case .Email:
            presentMailViewController([profile.email], subject: "Hey", messageBody: "")

        default:
            break
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if let profileHeaderView = (collectionView!.dataSource as ProfileDetailDataSource).profileHeaderView {
            let contentOffset = scrollView.contentOffset
            let minOffsetToMakeChanges: CGFloat = 20.0
            
            // Do not change anything unless user scrolls up more than 20 points
            if contentOffset.y > minOffsetToMakeChanges {
                
                // Scale down the image and reduce opacity
                let profileImageFractionValue = 1.0 - (contentOffset.y - minOffsetToMakeChanges)/profileHeaderView.profileImage.frameY
                profileHeaderView.profileImage.alpha = profileImageFractionValue
                if profileImageFractionValue >= 0 {
                    var transform = CGAffineTransformMakeScale(profileImageFractionValue, profileImageFractionValue)
                    profileHeaderView.profileImage.transform = transform
                }
                
                // Reduce opacity of the name and title label at a faster pace
                let titleLabelAlpha = 1.0 - contentOffset.y/(profileHeaderView.titleLabel.frameY - 40.0)
                profileHeaderView.titleLabel.alpha = titleLabelAlpha
                profileHeaderView.nameLabel.alpha = 1.0 - contentOffset.y/(profileHeaderView.nameLabel.frameY - 40.0)
                profileHeaderView.nameNavLabel.alpha = titleLabelAlpha <= 0.0 ? profileHeaderView.nameNavLabel.alpha + 1/20 : 0.0
            }
            else {
                profileHeaderView.nameLabel.alpha = 1.0
                profileHeaderView.nameNavLabel.alpha = 0.0
                profileHeaderView.titleLabel.alpha = 1.0
                profileHeaderView.profileImage.alpha = 1.0
                profileHeaderView.profileImage.transform = CGAffineTransformIdentity
            }
        }
    }
}
