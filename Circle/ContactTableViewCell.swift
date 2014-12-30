//
//  ContactTableViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class ContactTableViewCell: MGSwipeTableCell {

    @IBOutlet weak private(set) var name: UILabel!
    @IBOutlet weak private(set) var profileImg: UIImageView!
    @IBOutlet weak private(set) var title: UILabel!
    
    var addQuickActions: Bool!
    var person:Person! {
        didSet {
            populateData()
        }
    }

    class var classReuseIdentifier: String {
        return "ContactCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        profileImg.makeItCircular(false)
    }

    func addQuickActionButtons() {
        let emailButton = MGSwipeButton(
            title: "",
            icon: UIImage(named: "Email"),
            backgroundColor: UIColor.accessoryButtonBackgroundColor(),
            padding:20)

        let messageButton = MGSwipeButton(
            title: "",
            icon: UIImage(named: "Messages"),
            backgroundColor: UIColor.accessoryButtonBackgroundColor(),
            padding:20)

        rightButtons = [messageButton, emailButton]
    }

    private func populateData() {
        name.text = person.firstName + " " + person.lastName
        title.text = person.title
        profileImg.setImageWithPerson(person)
        if addQuickActions == true {
            addQuickActionButtons()
            contentView.backgroundColor = UIColor.accessoryButtonBackgroundColor()
        }
    }
}
