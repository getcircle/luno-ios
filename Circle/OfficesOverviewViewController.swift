//
//  OfficesOverviewViewController.swift
//  Circle
//
//  Created by Ravi Rani on 1/24/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class OfficesOverviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak private(set) var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private(set) var mapHeaderCollectionView: UICollectionView!
    
    private(set) var dataSource = OfficesOverviewDataSource()
    private(set) var delegate = OfficesOverviewCollectionViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        edgesForExtendedLayout = .None
        configureCollectionView()
        configureMapHeaderCollectionView()
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
    }
    
    private func configureMapHeaderCollectionView() {
        mapHeaderCollectionView.backgroundColor = UIColor.viewBackgroundColor()
        mapHeaderCollectionView.registerNib(
            UINib(nibName: "MapHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: MapHeaderCollectionReusableView.classReuseIdentifier
        )

        mapHeaderCollectionView.allowsSelection = false
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let office = dataSource.contentAtIndexPath(indexPath)? as? OrganizationService.Containers.Location {
            trackOfficeSelected(office)
            var officeDetailVC = OfficeDetailViewController()
            (officeDetailVC.dataSource as OfficeDetailDataSource).selectedOffice = office
            navigationController?.pushViewController(officeDetailVC, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // This function should never get called for this specific use case
        return UICollectionViewCell()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(
            kind,
            withReuseIdentifier: MapHeaderCollectionReusableView.classReuseIdentifier,
            forIndexPath: indexPath
        ) as MapHeaderCollectionReusableView
        
        supplementaryView.setData(offices: dataSource.offices)
        supplementaryView.allowInteraction = true
        return supplementaryView
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSizeMake(
            mapHeaderCollectionView.frameWidth,
            mapHeaderCollectionView.frameHeight
        )
    }
    
    // MARK: - Tracking
    
    func trackOfficeSelected(office: OrganizationService.Containers.Location) {
        let properties = [
            TrackerProperty.withKey(.ActiveViewController).withString(self.dynamicType.description()),
            TrackerProperty.withKey(.Source).withSource(.Overview),
            TrackerProperty.withKey(.SourceOverviewType).withOverviewType(.Offices),
            TrackerProperty.withKey(.Destination).withSource(.Detail),
            TrackerProperty.withKey(.DestinationDetailType).withDetailType(.Office),
            TrackerProperty.withDestinationId("office_id").withString(office.id)
        ]
        Tracker.sharedInstance.track(.DetailItemTapped, properties: properties)
    }
}
