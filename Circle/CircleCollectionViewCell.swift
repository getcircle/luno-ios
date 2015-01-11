//
//  CircleCollectionViewCell.swift
//  Circle
//
//  Created by Ravi Rani on 12/29/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit

// Size calculation method
enum SizeCalculation {
    case Fixed
    case Dynamic
}

class CircleCollectionViewCell: UICollectionViewCell {

    // Reuse identifier for dequeuing and reusing cells
    class var classReuseIdentifier: String {
        return "CircleCollectionViewCell"
    }
    
    // Fixed width for cases where size is fixed. 
    // NOTE: This does not account for section insets.
    class var width: CGFloat {
        return UIScreen.mainScreen().bounds.width
    }

    // Fixed height for cases where size is fixed
    // NOTE: This does not account for section insets.
    class var height: CGFloat {
        return 44.0
    }
    
    // Default min. inter item spacing expected for the cell
    class var interItemSpacing: CGFloat {
        return 0.0
    }
    
    // Default min. line spacing expected by the cell
    class var lineSpacing: CGFloat {
        return 1.0
    }

    // If the size calculation method is set to Fixed, the
    // collection views call width and height class variables.
    // If not it instantiates a prototype cell, sets the content and
    // asks for the intrinsic content size of the cell
    // Subclass that want the size calculation method to be dynamic
    // must override intrinsicContentSize function
    class var sizeCalculationMethod: SizeCalculation {
        return .Fixed
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = UIView(forAutoLayout: ())
        selectedBackgroundView.backgroundColor = UIColor.controlHighlightedColor()
        selectedBackgroundView.opaque = true
        contentView.bringSubviewToFront(selectedBackgroundView)
        // Collection view does some trickery and removes constraints from
        // background views. So, we have to add it again in code
        selectedBackgroundView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    // Generic setData function..The cells receive content in this function
    // This function is expected to be overridden by every sub-class.
    // The sub-classes need to independently cast the received data in their appropriate
    // objects
    func setData(data: AnyObject) {
        fatalError("Subclasses need to override this and add specific data types")
    }
}
