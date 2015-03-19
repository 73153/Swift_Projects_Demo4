//
//  WebResultCell.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/7/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import UIKit

class WebResultCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel
    @IBOutlet var linkLabel: UILabel
    @IBOutlet var descriptionLabel: UILabel
    
    func configureForWebResult(result: WebResult) {
        titleLabel.text = result.title
        linkLabel.text = result.URL.description
        descriptionLabel.text = result.resultDescription
    }
}
