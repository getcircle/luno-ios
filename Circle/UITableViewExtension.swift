//
//  UITableViewExtension.swift
//  Circle
//
//  Created by Michael Hahn on 11/30/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

extension UITableView {
    
    func addDummyFooterView() {
        let footerView = UIView(frame: CGRectMake(0.0, 0.0, frame.size.width, 10.0))
        footerView.backgroundColor = UIColor.clearColor()
        tableFooterView = footerView
    }
    
}
