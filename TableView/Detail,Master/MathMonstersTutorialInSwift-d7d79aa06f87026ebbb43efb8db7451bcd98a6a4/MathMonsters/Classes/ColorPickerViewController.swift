//
//  ColorPickerViewController.swift
//  MathMonsters
//
//  Created by Alexander Figueroa on 2014-06-16.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

import Foundation
import UIKit

protocol ColorPickerDelegate {
    func selectedColor(newColor: UIColor)
}

let ColorPickerTableViewCellIdentifier = "Cell"

class ColorPickerViewController: UITableViewController {
    
    var colorNames = NSString[]()
    var delegate: ColorPickerDelegate?
    
    init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Set up the array of colors
        colorNames.append(NSString(string: "Red"))
        colorNames.append(NSString(string: "Green"))
        colorNames.append(NSString(string: "Blue"))
        
        // Make row selections persist
        clearsSelectionOnViewWillAppear = false
        
        // Calculate how tall the view should be by mutiplying
        // the individual row height by the total number of rows.
        let rowsCount = colorNames.count
        let singleRowHeight = 44.0 // Default row height for UITableViewCells
        let totalRowsHeight = rowsCount * Int(singleRowHeight)
        
        // Calculate how wide the view should be by finding how wide
        // each string is expect to be
        var largestLabelWidth: CGFloat = 0
        
        for colorName in colorNames {
            // Check size of text using default font for UITableViewCell's textLabel
            let labelSize = colorName.sizeWithAttributes(NSDictionary(object: UIFont.boldSystemFontOfSize(20.0), forKey: NSFontAttributeName))
            if labelSize.width > largestLabelWidth {
                largestLabelWidth = labelSize.width
            }
        }
        
        // Add a little padding to the width
        let popoverWidth = largestLabelWidth + 100
        
        // Set the property to tell the popover container how big this view will be
        preferredContentSize = CGSize(width: Int(popoverWidth), height: totalRowsHeight)
        
        // Adjust the tableView to have no unneccessary rows
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorInset = UIEdgeInsetsZero
    }
    
    func updateCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        cell.textLabel.text = colorNames[indexPath.row]
    }
    
    // MARK: UITableViewDataSource Methods
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return colorNames.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(ColorPickerTableViewCellIdentifier) as? UITableViewCell
        
        if !cell {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ColorPickerTableViewCellIdentifier)
        }
        
        updateCell(cell!, indexPath: indexPath)
        
        return cell
    }
    
    // MARK: UITableViewDelegate Methods
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let selectedColorName = colorNames[indexPath.row] as String
        
        // Create a var to hold the color, make its default color
        // something annoying and obvious so you can see if a case has been
        // missed.
        var color: UIColor
        
        // Set the color object based on the selected color name.
        switch selectedColorName {
            case "Red":
                color = UIColor.redColor()
            case "Green":
                color = UIColor.greenColor()
            case "Blue":
                color = UIColor.blueColor()
            default:
                color = UIColor.orangeColor()
        }
        
        // Notify the delegate if it exists
        delegate?.selectedColor(color)
    }
}