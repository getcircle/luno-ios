//
//  TeamGridItemCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 1/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TeamGridItemCollectionViewCell: CircleCollectionViewCell {

    enum SizeMode {
        case Regular
        case Compact
    }

    @IBOutlet weak private(set) var teamBackgroundImageView: UIImageView!
    @IBOutlet weak private(set) var teamLabel: UILabel!
    @IBOutlet weak private(set) var teamNameLetterLabel: UILabel!
    
    override class var classReuseIdentifier: String {
        return "TeamGridItemCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 155.0
    }

    override class var interItemSpacing: CGFloat {
        return 20.0
    }
    
    override class var lineSpacing: CGFloat {
        return 10.0
    }

    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }

    var sizeMode: SizeMode = .Regular

    override func awakeFromNib() {
        super.awakeFromNib()
        teamBackgroundImageView.makeItCircular(false)
    }

    override func intrinsicContentSize() -> CGSize {
        return self.dynamicType.sizeByMode(sizeMode)
    }
    
    override func setData(data: AnyObject) {
        if let team = data as? OrganizationService.Containers.Team {
            teamBackgroundImageView.backgroundColor = UIColor.teamHeaderBackgroundColor(team.id)
            teamLabel.text = team.name
            teamNameLetterLabel.text = team.name[0]
        }
    }
    
    class func sizeByMode(sizeMode: SizeMode) -> CGSize {
        var width: CGFloat
        switch sizeMode {
        case .Regular:
            width = 120.0
            break
            
        case .Compact:
            width = 100.0
            break
        }
        
        return CGSizeMake(width, TeamGridItemCollectionViewCell.height)
    }
}
