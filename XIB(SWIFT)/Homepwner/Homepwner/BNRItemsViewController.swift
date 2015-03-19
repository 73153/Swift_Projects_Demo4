//
//  BNRItemsViewController.swift
//  Homepwner
//
//  Created by Han Kang on 6/10/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit
@IBDesignable
class BNRItemsViewController: UITableViewController {
    
    @IBAction func addNewItem(sender:AnyObject) {
        let newItem = BNRItemStore.sharedStore.createItem()
        let detailViewController = BNRDetailViewController(isNew: true)
        detailViewController.item = newItem
        let navController = UINavigationController(rootViewController: detailViewController)
        navController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        let dismissBlock: () -> Void = {
            self.tableView!.reloadData()
        }
        detailViewController.dismissBlock = dismissBlock
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    init() {
        super.init(style:UITableViewStyle.Plain)
        let navItem = self.navigationItem!
        navItem.title = "Homepwner"
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add,
                                            target: self,
                                            action: "addNewItem:")
        navItem.leftBarButtonItem = self.editButtonItem()
        for i in 0...5 {
            BNRItemStore.sharedStore.createItem()
        }
    }
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    init(style:UITableViewStyle) {
        super.init(style:style)
    }
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView!.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "blah")
//        let header = self.headerView
//        self.tableView.tableHeaderView = header
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // #pragma mark - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return BNRItemStore.count
    }

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        var cell = tableView!.dequeueReusableCellWithIdentifier("blah", forIndexPath: indexPath) as UITableViewCell
        if indexPath!.row % 2 == 0 {
            cell.backgroundColor = UIColor.blueColor()
            cell.textColor = UIColor.whiteColor()
        }
        let items = BNRItemStore.items
        let item = items[indexPath!.row] as BNRItem
        cell.textLabel.text = item.description

        return cell
    }
    
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let items = BNRItemStore.items
            let item = items.objectAtIndex(indexPath!.row) as BNRItem
            BNRItemStore.sharedStore.removeItem(item)
            // Delete the row from the data source
            tableView!.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {
        BNRItemStore.sharedStore.moveItemAtIndex(fromIndexPath!.row, toIndex: toIndexPath!.row)
    }
    
    override func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath?) {
        let detailViewController = BNRDetailViewController(isNew:false)
        detailViewController.item = BNRItemStore.items[indexPath!.row] as BNRItem
        self.navigationController.pushViewController(detailViewController, animated: true)
    }
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
