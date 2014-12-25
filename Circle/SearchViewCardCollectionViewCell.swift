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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        customizeContainerView()
    }
    
    // MARK: - Configuration
    
    private func customizeContainerView() {
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.3).CGColor
        containerView.layer.shadowOffset = CGSizeMake(-1.0, -1.0)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.masksToBounds = false
    }
    
    // MARK: - Load People
    
    func setPeople(people: [Person]) {
    
        // Remove existing subviews if they exist
        for subview in imagesContainerView.subviews as [UIView] {
            subview.removeFromSuperview()
        }
        
        let imageWidthHeight: CGFloat = 30.0
        let containerWidth = imagesContainerView.frameWidth
        let padding: CGFloat = 20.0
        var currentX: CGFloat = 0.0
        for person in people {
            var personImage = UIImageView(frame: CGRectMake(currentX, 0.0, imageWidthHeight, imageWidthHeight))
            imagesContainerView.addSubview(personImage)
            personImage.contentMode = .ScaleAspectFill
            personImage.autoPinEdgeToSuperviewEdge(.Top)
            personImage.autoSetDimensionsToSize(CGSizeMake(imageWidthHeight, imageWidthHeight))
            personImage.autoPinEdgeToSuperviewEdge(.Leading, withInset: currentX)
            personImage.setImageWithPerson(person)
            personImage.makeItCircular(false)
            currentX += imageWidthHeight + padding
            if (containerWidth - currentX) < imageWidthHeight {
                break
            }
        }
    }
}
