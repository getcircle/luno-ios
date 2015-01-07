//
//  ProfileImagesCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/23/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class ProfileImagesCollectionViewCell: CircleCollectionViewCell {

    override class var classReuseIdentifier: String {
        return "ProfileImagesCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 50.0
    }
    
    @IBOutlet weak private(set) var cardContentView: UIView!
    
    private let numberOfProfileImageViews = 10
    private let profileImageWidthHeight: CGFloat = 30.0
    private let profileImageInterSpacing: CGFloat = 20.0

    private var profileImageViews = [UIImageView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureCardParentView()
        configureContentView()
    }

    // MARK: - Configuration
    
    private func configureCardParentView() {
//        cardParentView.layer.borderWidth = 1.0
//        cardParentView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.3).CGColor
//        cardParentView.layer.cornerRadius = 4.0
//        cardParentView.layer.masksToBounds = true
    }

    private func configureContentView() {
        let containerWidth = cardContentView.frameWidth
        var currentX: CGFloat = 0.0
        for i in 0...numberOfProfileImageViews {
            var profileImage = UIImageView(frame: CGRectMake(currentX, 0.0, profileImageWidthHeight, profileImageWidthHeight))
            cardContentView.addSubview(profileImage)
            profileImage.contentMode = .ScaleAspectFill
            profileImage.hidden = true
            profileImage.autoPinEdgeToSuperviewEdge(.Top)
            profileImage.autoSetDimensionsToSize(CGSizeMake(profileImageWidthHeight, profileImageWidthHeight))
            profileImage.autoPinEdgeToSuperviewEdge(.Leading, withInset: currentX)
            profileImage.makeItCircular(false)
            currentX += profileImageWidthHeight + profileImageInterSpacing
            profileImageViews.append(profileImage)
        }
    }
    
    // MARK: - Load People
    
    override func setData(data: AnyObject) {
        if let profiles = data as? [ProfileService.Containers.Profile] {
            let containerWidth = cardContentView.frameWidth
            var counter = 0
            
            profileImageViews = profileImageViews.map({
                ($0 as UIImageView).hidden = true
                return $0
            })
            for profile in profiles {
                var profileImage = profileImageViews[counter]
                profileImage.setImageWithProfile(profile)
                profileImage.hidden = false
                counter += 1
                if ((containerWidth - profileImage.frameRight - profileImageInterSpacing) < profileImageWidthHeight) || counter == 4 {
                    break
                }
            }
        }
    }
}
