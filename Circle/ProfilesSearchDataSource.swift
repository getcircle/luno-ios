//
//  ProfilesSearchDataSource.swift
//  Luno
//
//  Created by Felix Mo on 2015-09-28.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit

class ProfilesSearchDataSource: ProfilesDataSource {
    
    override class var cardSeparatorInset: UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 70.0, 0.0, 20.0)
    }
    
    override init() {
        super.init()
        
        cardType = .SearchResult
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        super.configureCell(cell, atIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.appSearchBackgroundColor()
    }
}