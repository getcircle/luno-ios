//
//  TeamDetailViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/17/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import ProtobufRegistry

class TeamDetailViewController: DetailViewController, EditTeamViewControllerDelegate {

    // MARK: - Initialization
    
    override func customInit() {
        super.customInit()

        dataSource = TeamDetailDataSource()
        delegate = CardCollectionViewDelegate()
    }
    
    // MARK: - Configuration
    
    override func configureCollectionView() {
        // Data Source
        collectionView.dataSource = dataSource
        
        // Delegate
        collectionView.delegate = delegate
        
        (layout as! StickyHeaderCollectionViewLayout).headerHeight = ProfileHeaderCollectionReusableView.height
        (dataSource as! TeamDetailDataSource).editImageButtonDelegate = self
        super.configureCollectionView()
    }
    
    // MARK: - Collection View delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let tappedCard = dataSource.cardAtSection(indexPath.section) {
            switch tappedCard.type {
            case .Profiles:
                if let profile = dataSource.contentAtIndexPath(indexPath) as? Services.Profile.Containers.ProfileV1 {
                    showProfileDetail(profile)
                }
                else if let team = dataSource.contentAtIndexPath(indexPath) as? Services.Organization.Containers.TeamV1 {
                    showTeamDetail(team)
                }

                
            case .Settings:
                let editTeamViewController = EditTeamViewController(nibName: "EditTeamViewController", bundle: nil)
                let editTeamNavController = UINavigationController(rootViewController: editTeamViewController)
                editTeamViewController.team = (dataSource as! TeamDetailDataSource).team
                editTeamViewController.editTeamViewControllerDelegate = self
                navigationController?.presentViewController(editTeamNavController, animated: true, completion: nil)

            default:
                break
            }
        }
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let profileHeaderView = (dataSource as! TeamDetailDataSource).profileHeaderView {
            profileHeaderView.adjustViewForScrollContentOffset(scrollView.contentOffset)
        }
    }

    // MARK: - EditTeamViewControllerDelegate
    
    func onTeamDetailsUpdated(team: Services.Organization.Containers.TeamV1) {
        (dataSource as! TeamDetailDataSource).team = team
        loadData()
    }
    
    // Image Upload
    
    internal override func handleImageUpload(completion: () -> Void) {
        let dataSource = (self.dataSource as! TeamDetailDataSource)
        if let newImage = imageToUpload {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            Services.Media.Actions.uploadImage(
                newImage,
                forMediaType: .Team,
                withKey: dataSource.team.id
            ) { (mediaURL, error) -> Void in
                if let mediaURL = mediaURL {
                    let teamBuilder = dataSource.team.toBuilder()
                    teamBuilder.imageUrl = mediaURL
                    Services.Organization.Actions.updateTeam(teamBuilder.build()) { (team, error) -> Void in
                        if let team = team {
                            dataSource.team = team
                            hud.hide(true)
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    internal override func reloadHeader() {
        if let dataSource = dataSource as? TeamDetailDataSource {
            if let headerView = dataSource.profileHeaderView {
                headerView.setTeam(dataSource.team)
            }
        }
    }
}
