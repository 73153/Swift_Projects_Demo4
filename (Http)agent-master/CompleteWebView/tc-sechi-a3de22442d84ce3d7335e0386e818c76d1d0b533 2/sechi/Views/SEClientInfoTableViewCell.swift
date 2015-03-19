//
//  SEClientInfoTableViewCell.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  Custom table view cell for single client view screen
 */
class SEClientInfoTableViewCell: SESwipeableTableViewCell {
    
    @IBOutlet var clientLabel: UILabel
    @IBOutlet var contactLabel: UILabel
    @IBOutlet var phoneLabel: UILabel
    @IBOutlet var emailLabel: UILabel
    
    @IBOutlet var callButton: UIButton
    
    /**
     *  Calculates height needed to properly display cell based on current content
     *
     *  @return height of the cell
     */
    func cellHeightNeeded() -> Float {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
    
        var clientLabelHeight = self.clientLabel.text.bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.clientLabel.frame.size.width, CGFLOAT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.clientLabel.font], context: nil)
    
        return (clientLabelHeight.size.height * 4) + (5 * 4)
    }
    
}
