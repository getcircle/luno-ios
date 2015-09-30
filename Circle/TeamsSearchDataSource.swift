//
//  TeamsSearchDataSource.swift
//  Luno
//
//  Created by Felix Mo on 2015-09-28.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit

class TeamsSearchDataSource: TeamsOverviewDataSource {
    
    override init() {
        super.init()
        
        cardType = .SearchResult
    }
    
    override func configureCell(cell: CircleCollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        super.configureCell(cell, atIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.appSearchBackgroundColor()
    }
}
