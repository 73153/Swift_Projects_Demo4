//
//  RightViewController.swift
//  MathMonsters
//
//  Created by Alexander Figueroa on 2014-06-15.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

import Foundation
import UIKit

class RightViewController: UIViewController, MonsterSelectionDelegate, UISplitViewControllerDelegate, ColorPickerDelegate, UIPopoverControllerDelegate {
    
    @IBOutlet var nameLabel: UILabel
    @IBOutlet var descriptionLabel: UILabel
    @IBOutlet var iconImageView: UIImageView
    @IBOutlet var weaponImageView: UIImageView
    @IBOutlet var navBarItem: UINavigationItem
    
    var popover: UIPopoverController?
    var colorPicker: ColorPickerViewController?
    var colorPickerPopover: UIPopoverController?
    
    var _monster: Monster? {
        didSet {
            refreshUI()
        }
    }
    
    //  There are no implicit ivars so in order to perform a custom getter/setter pattern
    //  as would be common in objective-c when you wish to override a setter, this
    //  approach must be used. This is a computed property which makes reference to an
    //  internal _monster var
    var monster: Monster {
        get {
            return self._monster!
        }
        set {
            if self._monster != newValue {
                self._monster = newValue
            }
        }
    }
    
    // MARK: View Management Methods
    override func viewDidLoad() {
        refreshUI()
        super.viewDidLoad()
    }
    
    func refreshUI() {
        // Since this method can be called prior to launching the view due to the ability
        // to set the monster property prior to loading the view, this check is to ensure
        // we avoid an Optional.None error
        if (self.view){
            nameLabel.text = monster.name
            iconImageView.image = UIImage(named: monster.iconName)
            descriptionLabel.text = monster.monsterDescription
            weaponImageView.image = monster.weaponImage()
        }
    }
    
    // MARK: MonsterSelectionDelegate Methods
    func selectedMonster(newMonster: Monster?) {
        if newMonster {
            self.monster = newMonster!
        }
        
        // Dismisses the popover if it's showing
        popover?.dismissPopoverAnimated(true)
    }
    
    // MARK: UISplitViewControllerDelegate Methods
    func splitViewController(svc: UISplitViewController!, willHideViewController aViewController: UIViewController!, withBarButtonItem barButtonItem: UIBarButtonItem!, forPopoverController pc: UIPopoverController!) {
        // Grab the reference to the popover
        self.popover = pc
        
        // Set title of the bar button item
        barButtonItem.title = "Monsters"
        
        // Set the bar button item as the Nav Bar's leftBarButtonItem
        navBarItem.setLeftBarButtonItem(barButtonItem, animated: true)
    }
    
    func splitViewController(svc: UISplitViewController!, willShowViewController aViewController: UIViewController!, invalidatingBarButtonItem barButtonItem: UIBarButtonItem!) {
        // Remove the barButtonItem
        navBarItem.setLeftBarButtonItem(nil, animated: true)
        
        // Nil out the popover
        popover = nil
    }
    
    // MARK: IBActions
    @IBAction func chooseColorButtonTapped(sender: AnyObject) {
        if !colorPicker {
            // Create the ColorPickerViewController
            colorPicker = ColorPickerViewController(style: UITableViewStyle.Plain)
            
            // Set this view controller as the delegate
            colorPicker!.delegate = self
        }
        
        if !colorPickerPopover {
            // The color picker popover is not showing. Show it
            colorPickerPopover = UIPopoverController(contentViewController: colorPicker!)
            
            colorPickerPopover!.presentPopoverFromBarButtonItem(sender as UIBarButtonItem, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
            
            // Set the delegate
            colorPickerPopover!.delegate = self
        } else {
            // The color picker popover is showing. Hide it.
            colorPickerPopover!.dismissPopoverAnimated(true)
            colorPickerPopover = nil
        }
    }
    
    // MARK: ColorPickerDelegate
    func selectedColor(newColor: UIColor) {
        nameLabel.textColor = newColor
        
        // Dismiss the popover if its showing
        colorPickerPopover?.dismissPopoverAnimated(true)
        colorPickerPopover = nil
    }
    
    // MARK: UIPopoverControllerDelegate
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController!) {
        colorPickerPopover = nil
    }
}