//
//  SEJobClientInfoTableViewCell.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  Custom table view cell for single schedule view screen
 */
class SEJobClientInfoTableViewCell: SESwipeableTableViewCell {
    
    @IBOutlet var clientLabel: UILabel
    @IBOutlet var contactLabel: UILabel
    @IBOutlet var phoneLabel: UILabel
    @IBOutlet var infoTextView: UITextView
    @IBOutlet var callButton: UIButton
    
    /**
    *  Calculates height needed to properly display cell based on current content
    *
    *  @return height of the cell
    */
    func cellHeightNeeded() -> Float {
        var minimumHeight: Float = 145
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
        
        var clientLabelHeight = self.clientLabel.text.bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.clientLabel.frame.size.width, CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.clientLabel.font], context:nil)
        
        var infoLabelHeight = self.infoTextView.text.bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.infoTextView.frame.size.width - self.infoTextView.font.pointSize, CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: TextFieldFont, NSParagraphStyleAttributeName: paragraphStyle], context:nil)
        
        var singleLineInfoLabelHeight = "a".bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.infoTextView.frame.size.width - self.infoTextView.font.pointSize, CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: TextFieldFont, NSParagraphStyleAttributeName: paragraphStyle], context:nil)
        
        var calcHeight: Float = ((clientLabelHeight.size.height + 4) * 3) + 4 + singleLineInfoLabelHeight.size.height + infoLabelHeight.size.height + 9 + 2
        
        if calcHeight < minimumHeight {
            return minimumHeight
        }
        
        return calcHeight
    }
    
}
