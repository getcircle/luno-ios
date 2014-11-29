//
//  ProfileViewController.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var person: Person!
    private var dataSource: ProfileDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view, typically from a nib.
        customizeCollectionView()
        
        // Add data source
        assert(person != nil, "Person object needs to be set before loading this view.")
        dataSource = ProfileDataSource(person: person)
        collectionView.dataSource = dataSource
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.makeTransparent()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBar.makeOpaque()
        super.viewWillDisappear(animated)
    }

    private func customizeCollectionView() {
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        collectionView.registerNib(
            UINib(nibName: "ProfileAttributeCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: ProfileAttributeCollectionViewCell.classReuseIdentifier)

        collectionView.registerNib(
            UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.classReuseIdentifier)
    }
    
    // MARK: Layout delegate
    
    // This has to be implemented as a delegate method because the layout can only
    // set it for all headers
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(collectionView.frame.size.width, ProfileCollectionViewLayout.profileHeaderHeight)
        }
        
        return CGSizeZero
    }
}

