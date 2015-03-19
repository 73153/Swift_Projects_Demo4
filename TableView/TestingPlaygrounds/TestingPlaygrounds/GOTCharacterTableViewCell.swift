//
//  GOTCharacterTableViewCell.swift
//  TestingPlaygrounds
//
//  Created by sachindra pandey on 11/06/14.
//  Copyright (c) 2014 threeroots. All rights reserved.
//

import UIKit

class GOTCharacterTableViewCell: UITableViewCell {
    
    @IBOutlet var characterName : UILabel
    @IBOutlet var characterImage : UIImageView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCharacter(character: GOTCharacter){
        characterName.text = character.characterName;
        characterImage.image = UIImage(named:character.characterImageName);
    }
}
