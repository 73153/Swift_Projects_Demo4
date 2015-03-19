//
//  SuggestionCell.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/5/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import Foundation
import UIKit

class SuggestionCell: UICollectionViewCell {
    
    let cornerRadius: CGFloat = 16.0
    let widthPadding: CGFloat = 50.0
    let maxWidth: CGFloat = 296.0

    @IBOutlet var titleLabel: UILabel
    
    override var highlighted: Bool {
        willSet(highlighted) {
            configureAppearance(active: highlighted)
        }
    }
    override var selected: Bool {
        willSet(selected) {
            configureAppearance(active: selected)
        }
    }
    
    // Configure Content
    // ----------------------------------
    func configureForSuggestion(suggestion: String) {
        titleLabel.text = suggestion
        configureCellWidth()
    }
    
    func configureCellWidth() {
        let text = titleLabel.text as NSString
        var desiredWidth = text.sizeWithAttributes([
                NSFontAttributeName: titleLabel.font
            ]).width
        desiredWidth += widthPadding
        let realWidth = desiredWidth < maxWidth ? desiredWidth : maxWidth
        bounds.size = CGSize(width: realWidth, height: bounds.height)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // Configure Appearance
    // ----------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance(active: false)
    }
    
    func configureAppearance(#active: Bool) {
        
        if (active) {
            configureActiveAppearance()
        }
        else {
            configureNormalAppearance()
        }
    }
    
    func configureNormalAppearance() {
        contentView.backgroundColor = UIColor.whiteColor()
        titleLabel.textColor = Appearance.blueColor
    }
    
    func configureActiveAppearance() {
        contentView.backgroundColor = Appearance.blueColor
        titleLabel.textColor = UIColor.whiteColor()
    }
    
    // ----------------------------------
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawBorder()
    }
    
    func drawBorder() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1.0
        layer.borderColor = Appearance.blueColor.CGColor
    }
}
