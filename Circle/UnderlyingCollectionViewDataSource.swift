//
//  UnderlyingCollectionViewDataSource.swift
//  Circle
//
//  Created by Michael Hahn on 1/25/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit

private let EmptyHeaderReuseIdentifier = "EmptyHeaderReuseIdentifier"

class UnderlyingCollectionViewDataSource: CardDataSource {
    
    func addPlaceholderCard() {
        var placeholderCard = Card(cardType: .Placeholder, title: "Info")
        placeholderCard.sectionInset = UIEdgeInsetsZero
        placeholderCard.addHeader(
            headerClass: CircleCollectionReusableView.self
        )
        appendCard(placeholderCard)
    }
}
