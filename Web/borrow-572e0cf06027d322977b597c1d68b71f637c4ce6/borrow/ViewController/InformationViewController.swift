//
//  InformationViewController.swift
//  borrow
//
//  Created by Tobias Tiemerding on 6/3/14.
//
//

import UIKit
import MessageUI
import Social

class InformationViewController : UITableViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,UIActionSheetDelegate {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 2
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        if(section == 1){
            let productName = NSBundle.mainBundle().infoDictionary.objectForKey("CFBundleDisplayName") as NSString
            return "About \(productName)"
        }
        return nil
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let productName = NSBundle.mainBundle().infoDictionary.objectForKey("CFBundleDisplayName") as String
        var cell: UITableViewCell?
        
        if (indexPath.section == 0 && indexPath.row < 2) || (indexPath.section == 1 && indexPath.row == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("Value1CellIdentifier") as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: "Value1CellIdentifier")
            }

            if(indexPath.section == 0){
                cell!.selectionStyle = .Gray
                cell!.accessoryType = .DisclosureIndicator;
                
                let productNameLowercase = productName.lowercaseString
                if(indexPath.row == 0){
                    cell!.textLabel.text = NSLocalizedString("App-Support", comment: "")
                    cell!.detailTextLabel.text = "info@\(productNameLowercase)-app.com"
                } else if(indexPath.row == 1){
                    cell!.textLabel.text = NSLocalizedString("Homepage", comment: "")
                    cell!.detailTextLabel.text = "www.\(productNameLowercase)-app.com"
                }
            } else {
                if(indexPath.row == 0){
                    cell!.selectionStyle = .None
                    cell!.accessoryType = .None;
                    
                    let infoDictionary = NSBundle.mainBundle().infoDictionary
                    let versionNumber = infoDictionary.objectForKey("CFBundleShortVersionString") as String
                    let buildNumber = infoDictionary.objectForKey("CFBundleVersion") as String
                    
                    cell!.textLabel.text = NSLocalizedString("Version", comment: "")
                    cell!.detailTextLabel.text = "\(versionNumber) (Build: \(buildNumber))"
                }
            }
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("DefaultCellIdentifier") as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "DefaultCellIdentifier")
                cell!.textLabel.numberOfLines = 0
            }
            
            // Content
            if(indexPath.section == 0){
                cell!.selectionStyle = .Gray
                cell!.accessoryType = .DisclosureIndicator;
                
                if(indexPath.row == 2){
                    cell!.textLabel.text = NSLocalizedString("Send feedback on iTunes", comment: "")
                } else if(indexPath.row == 3){
                    cell!.textLabel.text = NSLocalizedString("Tell a Friend about \(productName)", comment: "")
                }
            } else {
                if(indexPath.row == 1){
                    cell!.selectionStyle = .None
                    cell!.accessoryType = .None;
                    
                    cell!.textLabel.text = NSLocalizedString("Copyright © 2014, Markus Müller & Tobias Tiemerding, All rights reserved.", comment: "")
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if(indexPath.section == 1 && indexPath.row == 1){
            return 66
        }
        return 44
    }
    
    override func tableView(tableView: UITableView!, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 44
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView!, willSelectRowAtIndexPath indexPath: NSIndexPath!) -> NSIndexPath! {
        return indexPath.section == 0 ? indexPath : nil
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        switch indexPath.row {
        case 0:
            if(MFMailComposeViewController.canSendMail()){
                let productName = NSBundle.mainBundle().infoDictionary.objectForKey("CFBundleDisplayName") as NSString
                let productNameLowercase = productName.lowercaseString
                
                var mailComposeViewController: MFMailComposeViewController = MFMailComposeViewController()
                mailComposeViewController.mailComposeDelegate = self
                mailComposeViewController.setSubject(NSLocalizedString("Feedback for \(productName)", comment: ""))
                mailComposeViewController.setToRecipients(["info@\(productNameLowercase)-app.com"])
                
                navigationController.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                Helper.displayAlertWithTitle(NSLocalizedString("Device can't send mails", comment: ""), andMessage: NSLocalizedString("You can configure a mail account in the Settings App.", comment: ""), inViewController:self)
            }
        case 1:
            self.performSegueWithIdentifier("openWebViewController", sender: self)
        case 2:
            let productName = NSBundle.mainBundle().infoDictionary.objectForKey("CFBundleDisplayName") as NSString
            var alertController = UIAlertController(title: NSLocalizedString("Rate \(productName)", comment: ""), message: NSLocalizedString("In the App Store scroll way down to the bottom and submit a rating or a review for this app. Thank you.", comment: ""), preferredStyle: .ActionSheet)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler:{(action: UIAlertAction!) in
                tableView.deselectRowAtIndexPath(indexPath, animated:true)
                // Open App Store App
                // WARNING: - Set correct URL later on
                let appStoreURL = NSURL(string: "https://itunes.apple.com/de/app/fooBar")
                UIApplication.sharedApplication().openURL(appStoreURL)
            }))
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler:{(action: UIAlertAction!) in
                tableView.deselectRowAtIndexPath(indexPath, animated:true)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        case 3:
            var alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let productName = NSBundle.mainBundle().infoDictionary.objectForKey("CFBundleDisplayName") as NSString
            let productNameLowercase = productName.lowercaseString
            let deviceName = UIDevice.currentDevice().localizedModel
            let body = NSLocalizedString("I'm using \(productName) on my \(deviceName). Get it now on the App Store.", comment: "")
            
            
            // Add buttons depending on what social services are available
            if(MFMailComposeViewController.canSendMail()){
                alertController.addAction(UIAlertAction(title: NSLocalizedString("'Tell a Friend' via Mail", comment: ""), style: .Default, handler: {(action: UIAlertAction!) in
                    var mailComposeViewController: MFMailComposeViewController = MFMailComposeViewController()
                    mailComposeViewController.mailComposeDelegate = self
                    mailComposeViewController.setSubject(NSLocalizedString("Invite to use \(productName)", comment: ""))
                    mailComposeViewController.setMessageBody(body + " http://www.\(productNameLowercase)-app.com", isHTML: false)
                    
                    self.navigationController.presentViewController(mailComposeViewController, animated: true, completion: nil)
                }))
            }
            if(MFMessageComposeViewController.canSendText()){
                alertController.addAction(UIAlertAction(title: NSLocalizedString("'Tell a Friend' via Message", comment: ""), style: .Default, handler: {(action: UIAlertAction!) in
                    var messageComposeViewController: MFMessageComposeViewController = MFMessageComposeViewController()
                    messageComposeViewController.messageComposeDelegate = self
                    messageComposeViewController.body = body + " http://www.\(productNameLowercase)-app.com"
                    
                    self.navigationController.presentViewController(messageComposeViewController, animated: true, completion: nil)
                }))
            }
            if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)){
                alertController.addAction(UIAlertAction(title: NSLocalizedString("'Tell a Friend' via Twitter", comment: ""), style: .Default, handler: {(action: UIAlertAction!) in
                    self.shareWithService(SLServiceTypeTwitter, text: body, image: UIImage(named: "Icon"), URL: NSURL(string: "http://itunes.apple.com/de/app/borrow"))
                }))
            }
            if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)){
                alertController.addAction(UIAlertAction(title: NSLocalizedString("'Tell a Friend' via Facebook", comment: ""), style: .Default, handler: {(action: UIAlertAction!) in
                    self.shareWithService(SLServiceTypeFacebook, text: body, image: UIImage(named: "Icon"), URL: NSURL(string: "http://itunes.apple.com/de/app/borrow"))
                }))
            }
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler:{(action: UIAlertAction!) in
                tableView.deselectRowAtIndexPath(indexPath, animated:true)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        default:
            println("Unknown row selected.")
        }
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.identifier == "openWebViewController"){
            let navigationController = segue.destinationViewController as UINavigationController
            var webViewController = navigationController.topViewController as WebViewController
            webViewController.url = NSURL(string: "http://www.google.de")
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate / MFMessageComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
        
        if(result.value == MFMailComposeResultFailed.value || error != nil){
            Helper.displayAlertWithTitle(NSLocalizedString("Send failed", comment: ""), andMessage: NSLocalizedString("Your message has failed to send.", comment: ""), inViewController:self)
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        dismissViewControllerAnimated(true, completion: nil)
        
        if (result.value == MessageComposeResultFailed.value) {
            Helper.displayAlertWithTitle(NSLocalizedString("Send failed", comment: ""), andMessage: NSLocalizedString("Your message has failed to send.", comment: ""), inViewController:self)
        }
    }
    
    // MARK: - Helper
    func shareWithService(service: String!, text: String!, image: UIImage!, URL: NSURL!){
        var composeViewController = SLComposeViewController(forServiceType: service)
        composeViewController.setInitialText(text)
        composeViewController.addImage(image)
        composeViewController.addURL(URL)
        
        navigationController.presentViewController(composeViewController, animated: true, completion: nil)
    }
}
