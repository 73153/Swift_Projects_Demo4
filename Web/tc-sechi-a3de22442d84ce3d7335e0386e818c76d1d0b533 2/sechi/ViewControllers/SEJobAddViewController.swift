//
//  SEJobAddViewController.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  View controller used for displaying form to add new job.
 */
class SEJobAddViewController: SEViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    /**
     *  Pointer for object that will be created.
     */
    var job: SEJob!

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
    var clientCell: SETextFieldTableViewCell!
    var contactCell: SETextFieldTableViewCell!
    var phoneCell: SETextFieldTableViewCell!
    var infoCell: SETextFieldTableViewCell!
    var addressCell: SETextFieldTableViewCell!
    var notesCell: SETextFieldTableViewCell!

    /**
     *  Setup table view properties and cells that will be displayed
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupCells()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(74, 0, 0, 0)
    }

    /**
     *  Prepare cell for each object field that's a need to be filled.
     */
    func setupCells() {
        self.clientCell = self.tableView.dequeueReusableCellWithIdentifier(SETextFieldTableViewCellIdentifier) as SETextFieldTableViewCell
        self.clientCell.label = "Client:"
        self.clientCell.key = "clientNameC"
        self.clientCell.value = self.job.clientNameC
        
        self.contactCell = self.tableView.dequeueReusableCellWithIdentifier(SETextFieldTableViewCellIdentifier) as SETextFieldTableViewCell
        self.contactCell.label = "Contact:"
        self.contactCell.key = "contactNameC"
        self.contactCell.value = self.job.contactNameC
        
        self.phoneCell = self.tableView.dequeueReusableCellWithIdentifier(SETextFieldTableViewCellIdentifier) as SETextFieldTableViewCell
        self.phoneCell.label = "Phone:"
        self.phoneCell.key = "phoneC"
        self.phoneCell.value = self.job.phoneC
        
        self.infoCell = self.tableView.dequeueReusableCellWithIdentifier(SETextFieldTableViewCellIdentifier) as SETextFieldTableViewCell
        self.infoCell.label = "Info:"
        self.infoCell.key = "infoTextC"
        self.infoCell.value = self.job.infoTextC
        
        self.addressCell = self.tableView.dequeueReusableCellWithIdentifier(SETextFieldTableViewCellIdentifier) as SETextFieldTableViewCell
        self.addressCell.label = "Address:"
        self.addressCell.key = "jobAddressC"
        self.addressCell.value = self.job.jobAddressC
        
        self.notesCell = self.tableView.dequeueReusableCellWithIdentifier(SETextFieldTableViewCellIdentifier) as SETextFieldTableViewCell
        self.notesCell.label = "Notes:"
        self.notesCell.key = "notesC"
        self.notesCell.value = self.job.notesC
        
        self.datasource = [self.clientCell, self.contactCell, self.phoneCell, self.infoCell, self.addressCell, self.notesCell]
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
        var saveButton = self.setupNavigationBarSaveButton()
        saveButton.target = self
        saveButton.action = "saveButtonTouchedUpInside:"
    }

    /**
     *  After save button was pressed, values filled by the user are validated and if any of them is empty validation alert will be shown.
     *  If everything is ok, data will be saved and the view controller will be dismissed.
     *
     *  @param sender object that called the method
     */
    func saveButtonTouchedUpInside(sender: UIButton) {
        self.job = NSEntityDescription.insertNewObjectForEntityForName("SEJob", inManagedObjectContext: SERestClient.instance.managedObjectContext) as SEJob
        
        for cell in self.datasource {
            if cell.valueTextView.text == "" {
                self.job.managedObjectContext.deleteObject(self.job)
                var fieldName = cell.label!.stringByReplacingOccurrencesOfString(":", withString: "")
                UIAlertView(title: "Validation error", message: "\(fieldName) field cannot be empty", delegate: nil, cancelButtonTitle: "OK").show()
                return
            }
            
            self.job.setValue(cell.valueTextView.text, forKey: cell.key)
        }
        
        self.job.removed = "false"
        self.job.createdDate = NSDate.date()
        self.job.lastModifiedDate = NSDate.date()
        
        var error: NSError? = nil
        self.job.managedObjectContext.save(&error)
        
        if error {
            NSLog("%@", error!)
        } else {
            self.job.managedObjectContext.saveToPersistentStore(&error)
            if error {
                NSLog("%@", error!)
            }
        }
        
        if error {
            UIAlertView(title: "Error", message: "Error occured while saving data: " + error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
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
        if let cell = textView.superviewOfClass(SETextFieldTableViewCell) as? SETextFieldTableViewCell {
            var heightNeeded = cell.cellHeightForText(cell.valueTextView.text)
            if cell.frame.size.height != heightNeeded {
                cell.height = heightNeeded
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
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
