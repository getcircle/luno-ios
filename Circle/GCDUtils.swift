//
//  GCDUtils.swift
//  Circle
//
//  Created by Ravi Rani on 11/29/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import Foundation

/*
 * http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift
 */
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}