//
//  TwitterViewController.swift
//  Noles Football
//
//  Created by Jonathan Steele on 6/4/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

import UIKit
import Accounts
import Social

class TwitterViewController: UITableViewController
{    
    var list: NSArray = NSArray.array()

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
        
        let account: ACAccountStore = ACAccountStore()
        let accountType: ACAccountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        account.requestAccessToAccountsWithType(accountType, options: nil, completion:{ (granted: Bool, error: NSError!) -> Void in
            if granted == true {
                let arrayOfAccounts: NSArray = account.accountsWithAccountType(accountType) as NSArray
                if arrayOfAccounts.count > 0 {
                    let twitterAccount: ACAccount = arrayOfAccounts.lastObject as ACAccount
                    let requestAPI: NSURL = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/user_timeline.json")
                    
                    let parameters: NSMutableDictionary = NSMutableDictionary()
                    parameters.setObject("Seminoles_com", forKey:"screen_name")
                    parameters.setObject("100", forKey: "count")
                    
                    let posts: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestAPI, parameters: parameters)
                    posts.account = twitterAccount
                    
                    posts.performRequestWithHandler({ (data: NSData!, urlResponse: NSURLResponse!, error: NSError!) -> Void in
                        self.list = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSArray
                        if self.list.count != 0 {
                            dispatch_async(dispatch_get_main_queue(), {() in
                                self.tableView.reloadData()
                            })
                        }
                        })
                }
            }
            })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        var tweet: NSDictionary = list[indexPath.row] as NSDictionary
        if tweet["retweeted_status"].count > 0 {
            tweet = tweet["retweeted_status"] as NSDictionary
        }
        cell.textLabel.text = tweet.objectForKey("user").valueForKey("screen_name") as String
        cell.detailTextLabel.text = tweet.objectForKey("text") as String

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
