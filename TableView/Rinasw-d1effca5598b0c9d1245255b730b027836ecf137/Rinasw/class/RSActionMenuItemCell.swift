//
//  RSActionMenuItemCell.swift
//  Rinasw
//
//  Created by okenProg on 2014/06/08.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

import UIKit

struct RSActionMenuItem {
    var image: UIImage?
    var titleText: String?
    var subText: String?
}


class RSActionMenuItemCell: UITableViewCell {
    
    @IBOutlet var backgroundImageView: UIImageView
    @IBOutlet var titleLabel: UILabel
    @IBOutlet var subLabel: UILabel
    var blurEffectView: UIVisualEffectView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupBlurView()
    }
    
    func setupBlurView() {
        self.blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        self.blurEffectView!.backgroundColor = UIColor(white: 0.1, alpha: 0.3)
        self.backgroundImageView.transform = CGAffineTransformMakeScale(1.1, 1.1)
        self.blurEffectView!.frame = self.backgroundImageView.bounds
        self.backgroundImageView.addSubview(self.blurEffectView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
