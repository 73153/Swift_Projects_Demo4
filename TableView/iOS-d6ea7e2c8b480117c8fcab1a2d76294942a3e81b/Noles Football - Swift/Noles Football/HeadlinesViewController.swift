//
//  HeadlinesViewController.swift
//  Noles Football
//
//  Created by Jonathan Steele on 6/3/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

import UIKit

class HeadlinesViewController: UITableViewController
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
        
        let urlRequest: NSURLRequest = NSURLRequest(URL: NSURL.URLWithString("http://www.seminoles.com/headline-rss.xml"))
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
        let doc: GDataXMLDocument = GDataXMLDocument(data: data, options: 0, error: nil)
        let nodes: NSArray = doc.nodesForXPath("//item", error: nil)
        for node : AnyObject in nodes {
            let feed: Feed = Feed()
            
            let titles: NSArray = node.elementsForName("title") as NSArray
            if titles.count > 0 {
                let title : GDataXMLElement = titles.objectAtIndex(0) as GDataXMLElement
                feed.title = title.stringValue()
            }
            
            let links: NSArray = node.elementsForName("link") as NSArray
            if links.count > 0 {
                let link : GDataXMLElement = links.objectAtIndex(0) as GDataXMLElement
                feed.link = link.stringValue()
            }
            
            let pubDates: NSArray = node.elementsForName("pubDate") as NSArray
            if pubDates.count > 0 {
                let pubDate : GDataXMLElement = pubDates.objectAtIndex(0) as GDataXMLElement
                feed.pubDate = pubDate.stringValue()
            }
            list.addObject(feed)
        }
        tableView.reloadData()
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
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("HeadlinesCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let feed: Feed = list[indexPath.row] as Feed
        cell.textLabel.text = feed.title
        cell.detailTextLabel.text = feed.pubDate
        
        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let feed: Feed = list[indexPath.row] as Feed
        let webview: WebViewController = WebViewController(nibName: nil, bundle: nil)
        webview.setURL(feed.link)
        navigationController.pushViewController(webview, animated: true)
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
