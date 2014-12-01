//
//  ContactTableViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ContactTableViewCell: MGSwipeTableCell {

    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var title: UILabel!
    var addQuickActions: Bool! {
        didSet {
            if addQuickActions == true && self.rightButtons.count == 0 {
                addQuickActionButtons()
                contentView.backgroundColor = UIColor.accessoryButtonBackgroundColor()
            }
        }
    }
    
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
        let favoriteButton = MGSwipeButton(
            title: "",
            icon: UIImage(named: "Favorites"),
            backgroundColor: UIColor.accessoryButtonBackgroundColor(),
            padding: 16)

        self.leftButtons = [favoriteButton]

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

        self.rightButtons = [messageButton, emailButton]
    }

    private func populateData() {
        name.text = person.firstName + " " + person.lastName
        title.text = person.title
        profileImg.setImageWithPerson(person)
    }
}
