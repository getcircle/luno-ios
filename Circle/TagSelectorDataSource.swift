//
//  TagSelectorDataSource.swift
//  Circle
//
//  Created by Michael Hahn on 1/15/15.
//  Copyright (c) 2015 RH Labs Inc. All rights reserved.
//

import UIKit
import ProtobufRegistry

class TagSelectorDataSource: UICollectionViewDataSource {
    
    private var filteredTags = Array<ProfileService.Containers.Tag>()
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TagCollectionViewCell.classReuseIdentifier,
            forIndexPath: indexPath
            ) as TagCollectionViewCell
        
        // Configure the cell
        cell.tagLabel.text = filteredTags[indexPath.row].name.capitalizedString
        configureCellByTheme(cell)
        if animatedCell[indexPath] == nil {
            animatedCell[indexPath] = true
            cell.animateForCollection(collectionView, atIndexPath: indexPath)
        }
        
        // Manage Selection
        if cell.selected {
            cell.selectCell(false)
        }
        else if selectedTags.containsObject(filteredTags[indexPath.row].name) {
            cell.selectCell(false)
            cell.selected = true
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: nil)
        }
        else {
            cell.unHighlightCell(false)
        }
        
        return cell
    }

   
}
