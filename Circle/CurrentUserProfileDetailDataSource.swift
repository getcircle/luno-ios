//
//  CurrentUserProfileDetailDataSource.swift
//  Circle
//
//  Created by Ravi Rani on 3/14/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class CurrentUserProfileDetailDataSource: ProfileDetailDataSource {

    override func configureHeader(header: CircleCollectionReusableView, atIndexPath indexPath: NSIndexPath) {
        super.configureHeader(header, atIndexPath: indexPath)
        
        if sections.count > 0 && (indexPath.section - 1) >= 0 {
            if (sections[indexPath.section - 1].allowEmptyContent) {
                if let headerView = header as? ProfileSectionHeaderCollectionReusableView {
                    headerView.showAddEditButton = true
                }
            }
        }
    }
}
