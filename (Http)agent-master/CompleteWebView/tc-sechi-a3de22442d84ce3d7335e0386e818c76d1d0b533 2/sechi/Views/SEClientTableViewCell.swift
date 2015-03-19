//
//  SEClientTableViewCell.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  Custom table view cell for clients list screen
 */
class SEClientTableViewCell: SESwipeableTableViewCell {
    
    @IBOutlet var clientNameLabel: UILabel
    @IBOutlet var phoneLabel: UILabel
    
    @IBOutlet var deleteButtonBg: UIView
    @IBOutlet var callButtonBg: UIView
    
}
