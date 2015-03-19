//
//  ScheduleTableCell.swift
//  Noles Football
//
//  Created by Jonathan Steele on 6/7/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

import UIKit

class ScheduleTableCell: UITableViewCell
{
    @IBOutlet var awayTeam : UILabel
    @IBOutlet var awayScore : UILabel
    @IBOutlet var homeTeam : UILabel
    @IBOutlet var homeScore : UILabel
    @IBOutlet var date : UILabel
    
    init(style: UITableViewCellStyle, reuseIdentifier: String)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
}
