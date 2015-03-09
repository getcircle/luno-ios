//
//  TeamsOverviewViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/23/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TeamsOverviewViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak private(set) var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    private(set) var dataSource = TeamsOverviewDataSource()
    private(set) var delegate = CardCollectionViewDelegate()

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
        collectionView.backgroundColor = UIColor.appViewBackgroundColor()
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        (collectionView.delegate as CardCollectionViewDelegate).delegate = self
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
    }
    
    // MARK: - Collection View Delegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let team = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Team {
            
            var teamDetailVC = TeamDetailViewController()
            (teamDetailVC.dataSource as TeamDetailDataSource).selectedTeam = team
            navigationController?.pushViewController(teamDetailVC, animated: true)
        }
    }

    // MARK: - Orientation change
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//        (collectionView.collectionViewLayout as UICollectionViewFlowLayout).itemSize = CGSizeMake(size.width, rowHeight)
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
}
