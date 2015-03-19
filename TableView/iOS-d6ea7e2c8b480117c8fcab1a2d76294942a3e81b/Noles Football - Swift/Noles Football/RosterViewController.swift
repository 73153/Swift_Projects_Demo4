//
//  RosterViewController.swift
//  Noles Football
//
//  Created by Jonathan Steele on 6/3/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

import UIKit

class RosterViewController: UITableViewController
{    
    var staffList : NSMutableArray = NSMutableArray.array()
    var playerList : NSMutableArray = NSMutableArray.array()

    init(style: UITableViewStyle)
    {
        super.init(style: style)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let urlRequest: NSURLRequest = NSURLRequest(URL: NSURL.URLWithString("http://grfx.cstv.com/schools/fsu/data/xml/roster/m-footbl-2013.xml"))
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(),
            completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let httpResponse: NSHTTPURLResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode/100 == 2 {
                let doc: GDataXMLDocument = GDataXMLDocument(data: data, options: 0, error: nil)
                self.handleStaffParsing(doc)
                self.handlePlayerParsing(doc)
                self.tableView.reloadData()
            }
            })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    func handleStaffParsing(doc: GDataXMLDocument)
    {
        let nodes: NSArray = doc.nodesForXPath("//asst_coach_lev1 | //asst_coach_lev2 | //asst_coach_lev3 | //head_coach | //other", error: nil)
        for node : AnyObject in nodes {
            let rostersObject: Rosters = Rosters()
            
            let firstNames : NSArray = node.elementsForName("first_name") as NSArray
            if firstNames.count > 0 {
                let firstName : GDataXMLElement = firstNames.objectAtIndex(0) as GDataXMLElement
                rostersObject.firstName = firstName.stringValue()
            }
            
            let lastNames: NSArray = node.elementsForName("last_name") as NSArray
            if lastNames.count > 0 {
                let lastName : GDataXMLElement = lastNames.objectAtIndex(0) as GDataXMLElement
                rostersObject.lastName = lastName.stringValue()
            }
            
            let positions : NSArray = node.elementsForName("position") as NSArray
            if positions.count > 0 {
                let pos : GDataXMLElement = positions.objectAtIndex(0) as GDataXMLElement
                rostersObject.postiton = pos.stringValue()
            }
            staffList.addObject(rostersObject)
        }
    }
    
    func handlePlayerParsing(doc: GDataXMLDocument)
    {
        let nodes: NSArray = doc.nodesForXPath("//player", error: nil)
        for node : AnyObject in nodes {
            let rostersObject: Rosters = Rosters()
            
            let firstNames : NSArray = node.elementsForName("first_name") as NSArray
            if firstNames.count > 0 {
                let firstName : GDataXMLElement = firstNames.objectAtIndex(0) as GDataXMLElement
                rostersObject.firstName = firstName.stringValue()
            }
            
            let lastNames: NSArray = node.elementsForName("last_name") as NSArray
            if lastNames.count > 0 {
                let lastName : GDataXMLElement = lastNames.objectAtIndex(0) as GDataXMLElement
                rostersObject.lastName = lastName.stringValue()
            }
            
            let positions : NSArray = node.elementsForName("position") as NSArray
            if positions.count > 0 {
                let pos : GDataXMLElement = positions.objectAtIndex(0) as GDataXMLElement
                rostersObject.postiton = pos.stringValue()
            }
            playerList.addObject(rostersObject)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        // Return the number of rows in the section.
        if section == 0 {
            return staffList.count
        }
        return playerList.count
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String!
    {
        if section == 0 {
            return "Staff"
        }
        return "Player"
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("RostersCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        var roster: Rosters
        if indexPath.section == 0 {
            roster = staffList[indexPath.row] as Rosters
        } else {
            roster = playerList[indexPath.row] as Rosters
        }
        cell.textLabel.text = roster.firstName.stringByAppendingString(" \(roster.lastName)")
        cell.detailTextLabel.text = roster.postiton

        return cell
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}
