//
//  ContactInfoViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/25/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ContactInfoViewController: CircleAlertViewController {
    
    var profile: ProfileService.Containers.Profile!

    private var collectionView: UICollectionView!
    private var collectionViewDelegate = CardCollectionViewDelegate()
    private var collectionViewDataSource = ProfileDetailDataSource()
    private var collectionViewLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assert(profile != nil, "Profile should be set when presenting this view controller")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func configureModalParentView() {
        parentContainerView.addRoundCorners(radius: 0.0)
        
        var titleLabel = UILabel(forAutoLayout: ())
        titleLabel.opaque = true
        titleLabel.backgroundColor = UIColor.tabBarTintColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.appModalTitleLabelFont()
        titleLabel.textAlignment = .Center
        let titleText = NSLocalizedString(
            "Contact Info", 
            comment: "Title of window showing user's contact info"
        ).uppercaseStringWithLocale(NSLocale.currentLocale())
        titleLabel.attributedText = NSAttributedString(
            string: titleText,
            attributes: [
                NSKernAttributeName: NSNumber(double: 2.0),
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont.appModalTitleLabelFont()
            ]
        )
        parentContainerView.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        titleLabel.autoSetDimension(.Height, toSize: 60.0)
     
        collectionView = UICollectionView(
            frame: parentContainerView.bounds, 
            collectionViewLayout: collectionViewLayout
        )
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        collectionView.opaque = true
        collectionView.backgroundColor = UIColor.whiteColor()
        parentContainerView.addSubview(collectionView)
        collectionViewDataSource.onlyShowContactInfo = true
        collectionViewDataSource.animateContent = false
        collectionViewDataSource.profile = profile
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = collectionViewDelegate
        collectionViewDataSource.loadData { (error) -> Void in
            self.collectionView.reloadData()
        }
        
        if let presentingVC = presentingViewController {
            if presentingVC is UICollectionViewDelegate {
                collectionViewDelegate.delegate = (presentingVC as UICollectionViewDelegate)
            }
        }
        collectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        collectionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel)
        
        // TODO: - Request exact height and set that as the constraint
        collectionView.autoSetDimension(.Height, toSize: 180.0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
