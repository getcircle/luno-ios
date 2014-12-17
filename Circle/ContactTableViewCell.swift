//
//  ContactTableViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

class ContactTableViewCell: MGSwipeTableCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var title: UILabel!
    
    var addQuickActions: Bool!
    var favoriteButton: MGSwipeButton?
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
            icon: UIImage(named: "Favorite"),
            backgroundColor: UIColor.accessoryButtonBackgroundColor(),
            padding: 16)
        favoriteButton.setImage(UIImage(named: "FavoriteFilled"), forState: .Selected)

        self.favoriteButton = favoriteButton
        leftButtons = [favoriteButton]

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
        favoriteButton?.selected = Favorite.isFavoritePerson(person)
    }
}
