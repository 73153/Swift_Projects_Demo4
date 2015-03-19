//
//  Monster.swift
//  MathMonsters
//
//  Created by Alexander Figueroa on 2014-06-15.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

import Foundation
import UIKit

enum Weapon {
    case Blowgun, NinjaStar, Fire, Sword, Smoke
}

class Monster: NSObject {
    var name: String?
    var monsterDescription: String?
    var iconName: String?
    var weapon: Weapon?
    
    // Factory class method to create new monsters gets converted to convenience init in Swift
    init(named name: String!, monsterDescription: String!, iconName: String!, weapon: Weapon!) {
        self.name = name
        self.monsterDescription = monsterDescription
        self.iconName = iconName
        self.weapon = weapon
    }
    
    // Convenience instance method to get UIImage representing the monster's weapon
    func weaponImage() -> UIImage? {
        
        switch self.weapon! {
            case .Blowgun:
                return UIImage(named: "blowgun.png")
            case .NinjaStar:
                return UIImage(named: "ninjastar.png")
            case .Fire:
                return UIImage(named: "fire.png")
            case .Sword:
                return UIImage(named: "sword.png")
            case .Smoke:
                return UIImage(named: "smoke.png")
            default:
                return nil
        }
    }
}