//
//  SEClientAddressTableViewCell.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

class SEClientAddressTableViewCell: SESwipeableTableViewCell {
    
    @IBOutlet var addressLabel: UITextView
    @IBOutlet var mapButton: UIButton
    
    /**
     *  Calculates height needed to properly display cell based on current content
     *
     *  @return height of the cell
     */
    func cellHeightNeeded() -> Float {
    
        var minimumHeight: Float = 63.0
    
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
    
        var infoLabelHeight = self.addressLabel.text.bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.addressLabel.frame.size.width - self.addressLabel.font.pointSize, CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: TextFieldFont, NSParagraphStyleAttributeName: paragraphStyle], context: nil)
    
        var singleLineInfoLabelHeight = "a".bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.addressLabel.frame.size.width - self.addressLabel.font.pointSize, CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: TextFieldFont, NSParagraphStyleAttributeName: paragraphStyle], context: nil)
    
        var calcHeight: Float = singleLineInfoLabelHeight.size.height + infoLabelHeight.size.height + 14 + 2
    
        if calcHeight < minimumHeight {
            return minimumHeight
        }
    
        return calcHeight
    }
    
}
