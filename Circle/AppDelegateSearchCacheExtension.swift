//
//  AppDelegateSearchCacheExtension.swift
//  Circle
//
//  Created by Michael Hahn on 1/8/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func loadStoreForUser() {
        ObjectStore.sharedInstance.repopulate()
    }
    
}
