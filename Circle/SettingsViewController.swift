//
//  SettingsViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/11/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    private var dataSource = SettingsDataSource()
    private var collectionViewDelegate = CardCollectionViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        configureCollectionView()
        configureNavigationBar()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = UIColor.viewBackgroundColor()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        dataSource.loadData { (error) -> Void in
            if error == nil {
                self.collectionView.reloadData()
            }
        }

        dataSource.registerCardHeader(collectionView)
        collectionView.dataSource = dataSource
        collectionViewDelegate.delegate = self
        collectionView.delegate = collectionViewDelegate
    }
    
    private func configureNavigationBar() {
        title = NSLocalizedString("Settings", comment: "Title of the settings view")
        let closeButtonItem = UIBarButtonItem(
            image: UIImage(named: "Down"), 
            style: .Plain, 
            target: self, 
            action: "closeButtonTapped:"
        )
        
        navigationItem.leftBarButtonItem = closeButtonItem
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButtonTapped(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject!) {
        dismissViewControllerAnimated(false, completion: { () -> Void in
            AuthViewController.logOut()
        })
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        switch dataSource.typeOfCell(indexPath) {
        case .LogOut:
            logoutButtonTapped(collectionView)
        default:
            break
        }
    }
}
