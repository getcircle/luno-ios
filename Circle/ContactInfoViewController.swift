//
//  ContactInfoViewController.swift
//  Circle
//
//  Created by Ravi Rani on 2/25/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import MessageUI
import ProtobufRegistry

class ContactInfoViewController: CircleAlertViewController, UICollectionViewDelegate, MFMailComposeViewControllerDelegate {
    
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
        collectionView.backgroundColor = UIColor.viewBackgroundColor()
        parentContainerView.addSubview(collectionView)
        collectionViewDataSource.onlyShowContactInfo = true
        collectionViewDataSource.animateContent = false
        collectionViewDataSource.profile = profile
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = collectionViewDelegate
        collectionViewDataSource.loadData { (error) -> Void in
            self.collectionView.reloadData()
        }
        collectionViewDelegate.delegate = self
        collectionView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        collectionView.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel)
        collectionView.autoSetDimension(.Height, toSize: collectionViewDataSource.heightOfContactInfoSection())
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch collectionViewDataSource.typeOfCell(indexPath) {
        case .Email:
            presentMailViewController(
            [profile.email],
            subject: "Hey",
            messageBody: "",
            completionHandler: nil
        )
        
        case .CellPhone:
            if let number = profile.cell_phone as String? {
                if let phoneURL = NSURL(string: NSString(format: "tel://%@", number.removePhoneNumberFormatting())) {
                    UIApplication.sharedApplication().openURL(phoneURL)
                }
            }
            
        default:
            break
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(
        controller: MFMailComposeViewController!,
        didFinishWithResult result: MFMailComposeResult,
        error: NSError!
        ) {
            dismissViewControllerAnimated(true, completion: nil)
    }
}
