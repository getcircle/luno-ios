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
    var person:Person! {
        didSet {
            populateData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        profileImg.makeItCircular(false)

        // Add accessory buttons
        addAccessoryButtons()
    }

    func addAccessoryButtons() {
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
        profileImg.setImageWithURL(NSURL(string: person.profileImageURL),
            placeholderImage: UIImage(named: "DefaultPerson"))
    }
}
