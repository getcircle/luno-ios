//
//  ContactTableViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 11/24/14.
//  Copyright (c) 2014 RavCode. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

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
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2.0
        profileImg.layer.masksToBounds = true
    }

    func setPerson(person: Person!) {
    private func populateData() {
        name.text = person.firstName + " " + person.lastName
        title.text = person.title
        profileImg.setImageWithURL(NSURL(string: person.profileImageURL),
            placeholderImage: UIImage(named: "DefaultPerson"))
    }
}
