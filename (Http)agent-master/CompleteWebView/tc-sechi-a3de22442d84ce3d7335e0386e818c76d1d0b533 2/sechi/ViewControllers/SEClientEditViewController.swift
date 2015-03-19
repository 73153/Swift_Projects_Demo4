//
//  SEClientsViewController.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  View controller used for displaying form to edit a client.
 */
class SEClientEditViewController: SEViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    /**
     *  SEClient object that will be edited.
     */
    var client: SEClient!

    /**
     *  Table view that will display the form
     */
    @IBOutlet var tableView: UITableView

    /**
     *  Datasource array with UITableViewCell objects that needs to be displayed.
     */
    var datasource: SETextFieldTableViewCell[]!

    /**
     *  UITableViewCell objects that are displayed in table view.
     */
    var companyCell: SETextFieldTableViewCell!
    var contactCell: SETextFieldTableViewCell!
    var phoneCell: SETextFieldTableViewCell!
    var emailCell: SETextFieldTableViewCell!

    /**
     *  Setup table view properties and cells that will be displayed
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupCells()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(68, 0, 0, 0)
    }

    /**
     *  Prepare cell for each object field that's a need to be filled.
     */
    func setupCells() {
        self.companyCell = self.tableView.dequeueReusableCellWithIdentifier(SETextFieldTableViewCellIdentifier) as SETextFieldTableViewCell
        self.companyCell.label = "Company:"
        self.companyCell.key = "companyNameC"
        self.companyCell.value = self.client.companyNameC
        
        self.contactCell = self.tableView.dequeueReusableCellWithIdentifier(SETextFieldTableViewCellIdentifier) as SETextFieldTableViewCell
        self.contactCell.label = "Contact:"
        self.contactCell.key = "name"
        self.contactCell.value = self.client.name
        
        self.phoneCell = self.tableView.dequeueReusableCellWithIdentifier(SETextFieldTableViewCellIdentifier) as SETextFieldTableViewCell
        self.phoneCell.label = "Phone:"
        self.phoneCell.key = "businessPhoneC"
        self.phoneCell.value = self.client.businessPhoneC
        
        self.emailCell = self.tableView.dequeueReusableCellWithIdentifier(SETextFieldTableViewCellIdentifier) as SETextFieldTableViewCell
        self.emailCell.label = "Email:"
        self.emailCell.key = "email"
        self.emailCell.value = self.client.email
        
        self.datasource = [self.companyCell, self.contactCell, self.phoneCell, self.emailCell]
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
        
        if let backBtn = self.navigationItem.leftBarButtonItem.customView as? UIButton {
            backBtn.removeTarget(self, action: "popViewControllerAnimated", forControlEvents: .TouchUpInside)
            backBtn.addTarget(self, action: "saveAndReturn", forControlEvents: .TouchUpInside)
        }
    }

    /**
     *  Called after back button was pressed. Validates the data in form, and displays the validation error if any of them is empty.
     *  If everything is ok, data is saved and view controller is dismissed.
     */
    func saveAndReturn() {
        for cell in self.datasource {
            if cell.changesWereMade && cell.valueTextView.text == "" {
                var fieldName = cell.label!.stringByReplacingOccurrencesOfString( ":", withString: "")
                UIAlertView(title: "Validation error", message: "\(fieldName) field cannot be empty", delegate: nil, cancelButtonTitle: "OK").show()
                return
            }
            
            self.client.setValue(cell.valueTextView.text, forKey: cell.key)
        }
        
        var error: NSError? = nil
        self.client.managedObjectContext.save(&error)
        
        if error {
            NSLog("%@", error!)
        } else {
            self.client.managedObjectContext.saveToPersistentStore(&error)
            if error {
                NSLog("%@", error!)
            }
        }
        
        if error {
            UIAlertView(title: "Error", message: "Error occured while saving data: " + error!.localizedDescription, delegate:nil, cancelButtonTitle: "OK").show()
        }
        
        self.navigationController.popViewControllerAnimated(true)
    }

    /**
     *  Hide keyboard on return when text view is a first responder
     *
     *  @param textView
     *  @param range
     *  @param text
     *
     *  @return BOOL should change the content of the text view
     */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    /**
     *  Scroll table view to cell that began editing.
     *
     *  @param textView text view that began editing.
     */
    func textViewDidBeginEditing(textView: UITextView) {
        var cell = textView.superviewOfClass(UITableViewCell) as UITableViewCell
        self.tableView.scrollToRowAtIndexPath(self.tableView.indexPathForCell(cell), atScrollPosition: .Top, animated: true)
    }

    /**
     *  Recalculate height of the cell based on the text view content after it changes.
     *
     *  @param textView UITextView that changed the content.
     */
    func textViewDidChange(textView: UITextView) {
        var cell = textView.superviewOfClass(SETextFieldTableViewCell) as SETextFieldTableViewCell
        var heightNeeded = cell.cellHeightForText(cell.valueTextView.text)
        if cell.frame.size.height != heightNeeded {
            cell.height = heightNeeded
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }

    /**
     *  Return table view cell from datasource and set it's text view delegate to self.
     *
     *  @param tableView
     *  @param indexPath
     *
     *  @return UITableViewCell to display in tableView at indexPath
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.datasource[indexPath.row]
        cell.valueTextView.delegate = self
        return cell
    }

    /**
     *  Return height for the table view cell for displaying in tableView at indexPath
     *
     *  @param tableView
     *  @param indexPath
     *
     *  @return height for the table view cell for displaying in tableView at indexPath
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> Float {
        var cell = self.datasource[indexPath.row]
        return cell.height
    }

}
