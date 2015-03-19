//
//  SEPaymentInfoTableViewCell.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  Custom table view cell for single payment view screen
 */
class SEPaymentInfoTableViewCell: SESwipeableTableViewCell {
    
    @IBOutlet var amountLabel: UILabel
    @IBOutlet var clientLabel: UILabel
    @IBOutlet var jobLabel: UILabel
    @IBOutlet var dateLabel: UILabel
    @IBOutlet var notesLabel: UITextView
    @IBOutlet var completeButton: UIButton
    
    /**
     *  Calculates height needed to properly display cell based on current content
     *
     *  @return height of the cell
     */
    func cellHeightNeeded() -> Float {
        
        var minimumHeight: Float = 145.0
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
        
        var clientLabelHeight = self.clientLabel.text.bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.clientLabel.frame.size.width, CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.clientLabel.font], context: nil)
        
        var infoLabelHeight = self.notesLabel.text.bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.notesLabel.frame.size.width - self.notesLabel.font.pointSize, CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: TextFieldFont, NSParagraphStyleAttributeName: paragraphStyle], context: nil)
        
        var singleLineInfoLabelHeight = "a".bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.notesLabel.frame.size.width - self.notesLabel.font.pointSize, CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: TextFieldFont, NSParagraphStyleAttributeName: paragraphStyle], context: nil)
        
        var calcHeight: Float = ((clientLabelHeight.size.height + 4) * 4) + 4 + singleLineInfoLabelHeight.size.height + infoLabelHeight.size.height + 9 + 2 + 70
        
        if calcHeight < minimumHeight {
            return minimumHeight
        }
        
        return calcHeight
    }
    
}
