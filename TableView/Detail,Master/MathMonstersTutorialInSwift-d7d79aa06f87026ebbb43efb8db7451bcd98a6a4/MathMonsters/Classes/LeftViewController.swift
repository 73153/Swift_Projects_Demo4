//
//  LeftViewController.swift
//  MathMonsters
//
//  Created by Alexander Figueroa on 2014-06-15.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

import Foundation
import UIKit

let LeftViewTableViewCellIdentifier: String = "Cell"

class LeftViewController: UITableViewController {
    // The monsters used for display
    var monsters = Monster[]()
    var delegate: MonsterSelectionDelegate?
    
    init(coder aDecoder: NSCoder!) {
        
        // Create the monster objects then add them to the array
        monsters.append(
            Monster(named: "Cat-Bot",
                monsterDescription: "MEE-OW",
                iconName: "meetcatbot.png",
                weapon: Weapon.Sword)
        )
        monsters.append(
            Monster(named: "Dog-Bot",
                monsterDescription: "BOW-WOW",
                iconName: "meetdogbot.png",
                weapon: Weapon.Blowgun)
        )
        monsters.append(
            Monster(named: "Explode-Bot",
                monsterDescription: "Tick, tick, BOOM!",
                iconName: "meetexplodebot.png",
                weapon: Weapon.Smoke)
        )
        monsters.append(
            Monster(named: "Fire-Bot",
                monsterDescription: "Will make you steamed",
                iconName: "meetfirebot.png",
                weapon: Weapon.NinjaStar)
        )
        monsters.append(
            Monster(named: "Ice-Bot",
                monsterDescription: "Has a chilling effect",
                iconName: "meeticebot.png",
                weapon: Weapon.Fire)
        )
        monsters.append(
            Monster(named: "Mini-Tomato-Bot",
                monsterDescription: "Extremely Handsome", 
                iconName: "meetminitomatobot.png", 
                weapon: Weapon.NinjaStar)
        )
        
        // Call the superclass init method last as per Intermediate Swift Video [29:00ish mark]
        super.init(coder: aDecoder)
    }
    
    func updateCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let monster = monsters[indexPath.row]
        cell.textLabel.text = monster.name
    }
    
    // MARK: UITableViewDataSource Methods
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return monsters.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        // Dequeue the cell
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(LeftViewTableViewCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        updateCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    // MARK: UITableViewDelegate Methods
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        // Could be null if selected row is out of range
        let selectedMonster = monsters[indexPath.row]
        delegate?.selectedMonster(selectedMonster)
    }
}