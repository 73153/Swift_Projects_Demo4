//
//  ScheduleViewController.swift
//  Noles Football
//
//  Created by Jonathan Steele on 6/4/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

import UIKit

class ScheduleViewController: UITableViewController
{
    var list : NSMutableArray = NSMutableArray.array()

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
        
        let urlRequest: NSURLRequest = NSURLRequest(URL: NSURL.URLWithString("http://cbs-amp2.silverchalice.co/cbs/api/events?schoolCode=fsu&sportCode=m-footbl"))
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(),
            completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let httpResponse: NSHTTPURLResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode/100 == 2 {
                self.handleParsing(data)
            }
            })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    func handleParsing(data: NSData)
    {
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHH:mm"

        let doc: GDataXMLDocument = GDataXMLDocument(data: data, options: 0, error: nil)
        let nodes: NSArray = doc.nodesForXPath("//current_events[@academicYear='2013']/*", error: nil)
        for node : AnyObject in nodes {
            let dateString : String = node.attributeForName("date").stringValue()
            
            let events : NSArray = node.elementsForName("event") as NSArray
            if events.count > 0 {
                let eventObject : Event = Event()
                let event : GDataXMLElement = events.objectAtIndex(0) as GDataXMLElement
                let easternTime : String = event.attributeForName("eastern_time").stringValue()
                let date : String = dateString.stringByAppendingString(easternTime)
                eventObject.date = dateFormatter.dateFromString(date)
                eventObject.homeScore = event.attributeForName("hs").stringValue()
                eventObject.homeTeam = event.attributeForName("hn").stringValue()
                eventObject.awayScore = event.attributeForName("vs").stringValue()
                eventObject.awayTeam = event.attributeForName("vn").stringValue()
                list.addObject(eventObject)
            }
        }
        self.tableView.reloadData()
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
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        // Return the number of rows in the section.
        return list.count
    }
    
    // TODO: How to do a custom tableView cell with five labels?
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SchedulesCell", forIndexPath: indexPath) as UITableViewCell
        // Configure the cell...
        let event: Event = list[indexPath.row] as Event
        cell.textLabel.text = event.awayTeam
        cell.detailTextLabel.text = event.awayScore
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
