//
//  RootNavigationDelegate.swift
//  Circle
//
//  Created by Ravi Rani on 12/31/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class RootNavigationDelegate: NSObject, UINavigationControllerDelegate {

    @IBOutlet weak private(set) var navigationController: UINavigationController!

    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            switch operation {
            case .Push:
                if let animator: UIViewControllerAnimatedTransitioning = toVC.pushAnimator {
                    return animator
                }

            case .Pop:
                if let animator: UIViewControllerAnimatedTransitioning = fromVC.popAnimator {
                    return animator
                }

            default:
                break
            }
            
            return nil
    }
}
