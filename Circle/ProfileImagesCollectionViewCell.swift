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
        return 60.0
    }
    
    @IBOutlet weak private(set) var cardContentView: UIView!
    
    private let numberOfProfileImageViews = 10
    private let profileImageWidthHeight: CGFloat = 34.0
    private let profileImageInterSpacing: CGFloat = 20.0

    private var profileImageViews = [CircleImageView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureContentView()
    }

    // MARK: - Configuration
    
    private func configureContentView() {
        let containerWidth = cardContentView.frameWidth
        var currentX: CGFloat = 0.0
        for i in 0...numberOfProfileImageViews {
            var profileImage = CircleImageView(frame: CGRectMake(currentX, 0.0, profileImageWidthHeight, profileImageWidthHeight))
            cardContentView.addSubview(profileImage)
            profileImage.contentMode = .ScaleAspectFill
            profileImage.hidden = true
            profileImage.autoPinEdgeToSuperviewEdge(.Top)
            profileImage.autoSetDimensionsToSize(CGSizeMake(profileImageWidthHeight, profileImageWidthHeight))
            profileImage.autoPinEdgeToSuperviewEdge(.Leading, withInset: currentX)
            profileImage.makeItCircular()
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
                ($0 as CircleImageView).hidden = true
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
