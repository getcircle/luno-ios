//
//  TeamsCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 1/18/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

struct TeamsCollectionViewCellNotifications {
    static let onTeamSelectedNotification = "com.ravcode.notification:onTeamSelectedNotification"
}

class TeamsCollectionViewCell: CircleCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    override class var classReuseIdentifier: String {
        return "TeamsCollectionViewCell"
    }
    
    override class var height: CGFloat {
        return 90.0
    }
    
    override class var sizeCalculationMethod: SizeCalculation {
        return .Dynamic
    }
    
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    @IBOutlet weak private var collectionViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak private var teamsLabel: UILabel!
    
    var showTeamsLabel: Bool = false {
        didSet {
            if showTeamsLabel {
                teamsLabel.hidden = false
                collectionViewTopSpaceConstraint.constant = 45.0
            }
            else {
                teamsLabel.hidden = true
                collectionViewTopSpaceConstraint.constant = 0.0
            }
        }
    }

    var selectedTeam: OrganizationService.Containers.Team?
    private var teams = Array<OrganizationService.Containers.Team>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        showTeamsLabel = false
        configureCollectionView()
        selectedBackgroundView = nil
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    // MARK: - Configuration
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.bounces = false
        collectionView.registerNib(
            UINib(nibName: "TeamGridItemCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: TeamGridItemCollectionViewCell.classReuseIdentifier
        )
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let team = teams[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TeamGridItemCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
        ) as TeamGridItemCollectionViewCell

        cell.setData(team)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(TeamGridItemCollectionViewCell.width - 20.0, TeamGridItemCollectionViewCell.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if showTeamsLabel {
            // Algin tags with the label if the label is shown
            return UIEdgeInsetsMake(10.0, teamsLabel.frameX, 10.0, teamsLabel.frameX)
        }
        else {
            return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let team = teams[indexPath.row]
        selectedTeam = team
        NSNotificationCenter.defaultCenter().postNotificationName(
            TeamsCollectionViewCellNotifications.onTeamSelectedNotification,
            object: nil,
            userInfo: ["team": team]
        )
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        selectedTeam = nil
    }
    
    // MARK: - Data Setter
    
    override func setData(data: AnyObject) {
        if let arrayOfTeams = data as? [OrganizationService.Containers.Team] {
            teams = arrayOfTeams
            collectionView.reloadData()
        }
    }
    
    // MARK: - Sizing
    
    override func intrinsicContentSize() -> CGSize {
        let collectionViewLayout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        let height = collectionViewLayout.collectionViewContentSize().height + collectionViewTopSpaceConstraint.constant
        return CGSizeMake(CircleCollectionViewCell.width, height)
    }
}
