//
//  SEPaymentViewController.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  View controller used for displaying single payment view.
 */
class SEPaymentViewController: SEViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {

    var payment: SEPayment!

    /**
     *  UITableView used to display object info.
     */
    @IBOutlet var tableView: UITableView

    /**
     *  Datasource with UITableViewCell identifiers used to display info.
     */
    var datasource: String[]!

    /**
     *  Temporary cell object used to calculate cell height.
     */
    var tempPaymentInfoCell: SEPaymentInfoTableViewCell!

    /**
     *  Setup table view properties and cells that will be displayed. Prepare temporary cells for use.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.datasource = [SEPaymentInfoTableViewCellIdentifier]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(68, 0, 0, 0)
        
        self.tempPaymentInfoCell = self.tableView.dequeueReusableCellWithIdentifier(SEPaymentInfoTableViewCellIdentifier) as SEPaymentInfoTableViewCell
    }

    /**
     *  Setup navigation bar visible, and it's buttons.
     *
     *  @param animated
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController.setNavigationBarHidden(false, animated: animated)
        self.setupNavigationBarBackButton()
        self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }

    /**
     *  Setup cell content
     *
     *  @param tableView UITableView that the cell will be displayed in
     *  @param indexPath NSIndexPath at which the cell will be displayed
     *
     *  @return UITableViewCell to display
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = self.datasource[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell
        
        if let clientInfoCell = cell as? SEPaymentInfoTableViewCell {
            var df = NSDateFormatter()
            df.timeStyle = .NoStyle
            df.dateStyle = .MediumStyle
            
            clientInfoCell.amountLabel.text = "\(self.payment.paymentAmountC)"
            clientInfoCell.clientLabel.text = self.payment.clientNameC
            clientInfoCell.jobLabel.text = self.payment.jobNameC
            clientInfoCell.dateLabel.text = df.stringFromDate(self.payment.paymentDateC)
            clientInfoCell.notesLabel.text = self.payment.paymentNotesC
            clientInfoCell.notesLabel.font = TextFieldFont
            clientInfoCell.notesLabel.contentInset = UIEdgeInsetsMake(-8,-4,0,0)
            clientInfoCell.notesLabel.userInteractionEnabled = false
            clientInfoCell.completeButton.hidden = self.payment.statusC == "Complete"
        }
        
        return cell
    }

    /**
     *  Update object status, and hide view controller.
     *
     *  @param sender object that called the method
     */
    @IBAction func completeButtonTouchedUpInside(sender: UIButton) {
        self.payment.statusC = "Complete"
        
        var error: NSError? = nil
        self.payment.managedObjectContext.save(&error)
        if error {
            NSLog("%@", error!)
        } else {
            self.payment.managedObjectContext.saveToPersistentStore(&error)
            if error {
                NSLog("%@", error!)
            }
        }
        
        self.navigationController.popViewControllerAnimated(true)
    }

    /**
     *  Calculate height needed for cell based on it's content.
     *
     *  @param tableView
     *  @param indexPath
     *
     *  @return height needed by a cell ti display properly all content.
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> Float {
        var df = NSDateFormatter()
        df.timeStyle = .NoStyle
        df.dateStyle = .MediumStyle
        switch indexPath.row {
            case 0:
                self.tempPaymentInfoCell.amountLabel.text = "\(self.payment.paymentAmountC)"
                self.tempPaymentInfoCell.clientLabel.text = self.payment.clientNameC
                self.tempPaymentInfoCell.jobLabel.text = self.payment.jobNameC
                self.tempPaymentInfoCell.dateLabel.text = df.stringFromDate(self.payment.paymentDateC)
                self.tempPaymentInfoCell.notesLabel.text = self.payment.paymentNotesC
                return self.tempPaymentInfoCell.cellHeightNeeded()
            default:
                return 44.0
        }
    }

    /**
     *  Forward current object to next view controller if it's able to save it.
     *
     *  @param segue  segue that's going to be performed
     *  @param sender object that initiated the segue
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        if segue.destinationViewController.respondsToSelector("setPayment:") {
            segue.destinationViewController.setValue(self.payment, forKey: "payment")
        }
    }

}
