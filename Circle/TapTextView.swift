//
//  TapTextView.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-18.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import UIKit

// Subclass of UITextView which allows for un-delayed interaction with attachments and links.
class TapTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addTapGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTapGestureRecognizer()
    }
    
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delaysTouchesBegan = false
        tapGestureRecognizer.delaysTouchesEnded = false
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let tapLocation = gestureRecognizer.locationInView(self)
        // Get the position of the content that was tapped on
        if let closestPosition = closestPositionToPoint(tapLocation) {
            // Image attachments may span more than one position so we need to look at a wider range
            let startPosition = positionFromPosition(closestPosition, offset: -1) ?? closestPosition
            let endPosition = positionFromPosition(closestPosition, offset: 1) ?? closestPosition
            if let textRange = textRangeFromPosition(startPosition, toPosition: endPosition) {
                // Make NSRange from UITextRange
                let startOffset = offsetFromPosition(beginningOfDocument, toPosition: textRange.start)
                let endOffset = offsetFromPosition(beginningOfDocument, toPosition: textRange.end)
                let range = NSMakeRange(startOffset, endOffset - startOffset)
                attributedText.enumerateAttributesInRange(range, options: [], usingBlock: { (attributes, range, stop) -> Void in
                    if let attachment = attributes[NSAttachmentAttributeName] as? NSTextAttachment {
                        self.delegate?.textView?(self, shouldInteractWithTextAttachment: attachment, inRange: range)
                        stop.memory = true
                    }
                    else if let url = attributes[NSLinkAttributeName] as? NSURL {
                        let allowedToInteractWithURL = (self.delegate?.textView?(self, shouldInteractWithURL: url, inRange: range) ?? true)
                        if self.selectable && allowedToInteractWithURL {
                            UIApplication.sharedApplication().openURL(url)
                        }
                        stop.memory = true
                    }
                })
            }
        }
    }
    
}
