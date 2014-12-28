//
//  SearchViewCardCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/23/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class SearchViewCardCollectionViewCell: UICollectionViewCell {

    class var classReuseIdentifier: String {
        return "SearchCardCollectionViewCell"
    }
    
    @IBOutlet weak private(set) var cardTitleLabel: UILabel!
    @IBOutlet weak private(set) var containerView: UIView!
    @IBOutlet weak private(set) var imagesContainerView: UIView!
    
    private let numberOfProfileImageViews = 10
    private let profileImageWidthHeight: CGFloat = 30.0
    private let profileImageInterSpacing: CGFloat = 20.0

    private var profileImageViews = [UIImageView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        configureContainerView()
        configureProfileImageViews()
    }
    
    private func configureProfileImageViews() {
        let containerWidth = imagesContainerView.frameWidth
        var currentX: CGFloat = 0.0
        for i in 0...numberOfProfileImageViews {
            var profileImage = UIImageView(frame: CGRectMake(currentX, 0.0, profileImageWidthHeight, profileImageWidthHeight))
            imagesContainerView.addSubview(profileImage)
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
    
    // MARK: - Configuration
    
    private func configureContainerView() {
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.3).CGColor
        
        containerView.layer.cornerRadius = 2.0
        containerView.layer.masksToBounds = true

//        containerView.layer.shadowOffset = CGSizeMake(-1.0, -1.0)
//        containerView.layer.shadowRadius = 4
//        containerView.layer.shadowOpacity = 0.2
//        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).CGPath;
//        containerView.layer.masksToBounds = false
    }
    
    // MARK: - Load People
    
    func setPeople(people: [Person]) {
        let containerWidth = imagesContainerView.frameWidth
        var counter = 0
        
        profileImageViews = profileImageViews.map({
            ($0 as UIImageView).hidden = true
            return $0
        })
        for person in people {
            var personImage = profileImageViews[counter]
            personImage.setImageWithPerson(person)
            personImage.hidden = false
            counter += 1
            if ((containerWidth - personImage.frameRight - profileImageInterSpacing) < profileImageWidthHeight) || counter == 4 {
                break
            }
        }
    }
}
