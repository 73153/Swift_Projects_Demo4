//
//  ViewController.swift
//  VisualEffect_ios8
//
//  Created by Dominik on 09/06/14.
//  Copyright (c) 2014 Dominik. All rights reserved.
//

import UIKit

extension Array {
    func each(callback: T -> ()) {
        for item in self {
            callback(item)
        }
    }
    
    
    func eachWithIndex(callback: (T, Int) -> ()) {
        var index = 0
        for item in self {
            callback(item, index)
            index += 1
        }
    }
}

class CustomTableViewCell: UITableViewCell {
    @IBOutlet var backgroundImage: UIImageView
    @IBOutlet var titleLabel: UILabel
    
    func loadItem(#title: String, image: String) {
        backgroundImage.image = UIImage(named: image)
        titleLabel.text = title
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView
    
    var items: (String, String)[] = [
        ("❤", "swift 1.jpeg"),
   
    ]
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customCell") as CustomTableViewCell
        
        var (title, image) = items[indexPath.row]
        
        cell.loadItem(title: title, image: image)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView!, didSelectRowAtindexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println("you selected cell #\(indexPath.row)")
    }

    func addEffects() {
        
        [
            UIBlurEffectStyle.Light,
            UIBlurEffectStyle.Dark,
            UIBlurEffectStyle.ExtraLight
        ].map {
            UIBlurEffect(style: $0)
        }.eachWithIndex { (effect, index) in
            var effectView = UIVisualEffectView(effect: effect)
            effectView.frame = CGRectMake(0, CGFloat(50 * index), 320, 50)
            self.view.addSubview(effectView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addEffects()
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "customCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

