//
//  HomelessViewController.swift
//  Circle
//
//  Created by Michael Hahn on 2/10/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

class HomelessViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.makeTransparent()
        view.backgroundColor = UIColor.appTintColor()
        infoLabel.textColor = UIColor.whiteColor()
    }

}
