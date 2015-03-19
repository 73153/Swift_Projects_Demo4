//
//  BNRReminderViewController.swift
//  HypnoNerd
//
//  Created by Han Kang on 6/9/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRReminderViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.tabBarItem.title = "Remind"
        // Custom initialization
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addReminder(sender:AnyObject) {
        var date = self.datePicker.date
        NSLog("setting a reminder for the date: \(date)")
        var notification = UILocalNotification()
        notification.alertBody = "Hypnotize me!"
        notification.fireDate = date
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.datePicker.minimumDate = NSDate(timeIntervalSinceNow: 60)
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
