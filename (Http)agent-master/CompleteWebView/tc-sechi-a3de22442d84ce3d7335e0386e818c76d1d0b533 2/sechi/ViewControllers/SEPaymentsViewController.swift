//
//  SEPaymentsViewController.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  View controller used for displaying list of payment objects.
 */
class SEPaymentsViewController: SEViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, SESwipeableTableViewCellDelegate, UIGestureRecognizerDelegate {

    /**
     *  Managed object context used by fetched results controller.
     */
    var managedObjectContext: NSManagedObjectContext!

    /**
     *  Table view with list of objects
     */
    @IBOutlet var tableView: UITableView

    /**
     *  Index path of cell that began process of removing (swipe, press delete button etc).
     */
    var indexPathToRemove: NSIndexPath?

    /**
     *  Gesture recognizer used to cancel the custom edit mode of the table view.
     */
    var editModeGestureRecognizer: UIPanGestureRecognizer!

    /**
     *  Setup views properties, gesture recognizer and initiates displayed objects sync.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.managedObjectContext = SERestClient.instance.managedObjectContext
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(68, 0, 0, 0)
        
        self.editModeGestureRecognizer = UIPanGestureRecognizer(target: self, action: "viewWasPanned:")
        self.view.addGestureRecognizer(self.editModeGestureRecognizer)
        self.editModeGestureRecognizer.delegate = self
        
        SERestClient.instance.refreshPaymentsList()
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
        var addButton = self.setupNavigationBarAddButton()
        addButton.addTarget(self, action: "addButtonTouchedUpInside:", forControlEvents: .TouchUpInside)
    }

    /**
     *  Show view controller with form for adding new object to the list.
     *
     *  @param sender button that called the method
     */
    func addButtonTouchedUpInside(sender: UIButton) {
        self.performSegueWithIdentifier(SEPushPaymentAddViewControllerSegue, sender: self)
    }

    /**
     *  Display confirm alert after pressing objects delete button.
     *
     *  @param sender object that sent the message
     */
    @IBAction func deleteButtonTouchedUpInside(sender: UIButton) {
        if let cell = sender.superviewOfClass(UITableViewCell) as? UITableViewCell {
            self.indexPathToRemove = self.tableView.indexPathForCell(cell)
            
            var alertView = UIAlertView(title: "Confirm", message: "Do you want to delete this client?", delegate: self, cancelButtonTitle: "NO")
            alertView.addButtonWithTitle("YES")
            alertView.show()
        }
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    /**
     *  If any swipeable cell is open at the moment of panning the screen, and the pan started not inside this open cell view. This cell will be closed.
     *
     *  @param panGestureRecognizer UIPanGestureRecognizer that recognized the pan gesture.
     */
    func viewWasPanned(panGestureRecognizer: UIPanGestureRecognizer) {
        if panGestureRecognizer.state == .Began {
            var cell = self.tableView.cellForRowAtIndexPath(self.indexPathToRemove) as SESwipeableTableViewCell
            var beginingTouchPoint = panGestureRecognizer.locationInView(cell)
            var xContains = beginingTouchPoint.x > 0 && beginingTouchPoint.x < cell.frame.size.width
            var yContains = beginingTouchPoint.y > 0 && beginingTouchPoint.y < cell.frame.size.height
            if !(xContains && yContains) {
                cell.closeCellAnimated(true)
                self.tableView.scrollEnabled = true
            }
        }
    }

    /**
     *  Disallow swipe gesture on visible cells when table view did start scrolling.
     *
     *  @param scrollView scrollView (table view) that begin scrolling.
     */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        var visibleCellsIndexPaths = self.tableView.indexPathsForVisibleRows() as NSIndexPath[]
        for indexPath in visibleCellsIndexPaths {
            var cell = self.tableView.cellForRowAtIndexPath(indexPath) as SESwipeableTableViewCell
            cell.swipeEnabled = false
        }
    }

    /**
     *  Allow swipe gesture on visible cells after scroll view (table view) did end decelerating.
     *
     *  @param scrollView scroll view (table view) that end decelerating.
     */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var visibleCellsIndexPaths = self.tableView.indexPathsForVisibleRows() as NSIndexPath[]
        for indexPath in visibleCellsIndexPaths {
            var cell = self.tableView.cellForRowAtIndexPath(indexPath) as SESwipeableTableViewCell
            cell.swipeEnabled = true
        }
    }

    /**
     *  Disable table view scrolling when swipe gesture was recognized on any swipeable cells.
     *
     *  @param cell SESwipeableTableViewCell that begin swipe gesture.
     */
    func swipeableCellWillStartMovingContent(cell: SESwipeableTableViewCell) {
        self.tableView.scrollEnabled = false
    }

    /**
     *  After opening a new cell, every other that was already opened will be closed.
     *
     *  @param cell SESwipeableTableViewCell that was opened.
     */
    func cellDidOpen(cell: SESwipeableTableViewCell) {
        var newIndexPathToRemove = self.tableView.indexPathForCell(cell)
        
        if self.indexPathToRemove && self.indexPathToRemove! != newIndexPathToRemove {
            var oldCell = self.tableView.cellForRowAtIndexPath(self.indexPathToRemove) as SESwipeableTableViewCell
            oldCell.closeCellAnimated(true)
        }
        
        self.indexPathToRemove = newIndexPathToRemove
        self.tableView.scrollEnabled = false
    }

    /**
     *  Enable table view scrolling after open cell was closed.
     *
     *  @param cell SESwipeableTableViewCell that was closed.
     */
    func cellDidClose(cell: SESwipeableTableViewCell) {
        self.tableView.scrollEnabled = true
    }

    /**
     *  Remove object from database or close opened cell if user confirmed or denied deleting of object in alert view.
     *
     *  @param alertView
     *  @param buttonIndex
     */
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            var payment = self.fetchedResultsController.objectAtIndexPath(self.indexPathToRemove) as SEPayment
            payment.removed = "true"
            var error: NSError? = nil
            payment.managedObjectContext.save(&error)
            if error {
                NSLog("%@", error!)
            } else {
                payment.managedObjectContext.saveToPersistentStore(&error)
                if error {
                    NSLog("%@", error!)
                }
            }
            self.indexPathToRemove = nil
        } else {
            var cell = self.tableView.cellForRowAtIndexPath(self.indexPathToRemove) as SESwipeableTableViewCell
            cell.closeCellAnimated(true)
            self.tableView.scrollEnabled = true
        }
    }

    /**
     *  Basic setup of UITableView with NSFetchedResultsViewController
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionInfo = self.fetchedResultsController.sections[section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(SEPaymentTableViewCellIdentifier) as SEPaymentTableViewCell
        cell.delegate = self
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> Float {
        return 75.0
    }


    /**
     *  Setup NSFetchedResultsController for providing data to UITableView
     */
    var fetchedResultsController: NSFetchedResultsController {
        get {
            if _fetchedResultsController {
                return _fetchedResultsController!
            }
        
            var fetchRequest = NSFetchRequest()
            var entity = NSEntityDescription.entityForName("SEPayment", inManagedObjectContext: self.managedObjectContext)
            fetchRequest.entity = entity
            fetchRequest.fetchBatchSize = 20
            var sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
            var deletedPredicate = NSPredicate(format: "NOT (removed LIKE %@)", "true")
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = deletedPredicate
            _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            _fetchedResultsController!.delegate = self
            
            var error: NSError? = nil
            if !self.fetchedResultsController.performFetch(&error) {
                NSLog("Unresolved error %@, %@", error!, error!.userInfo)
                abort()
            }
            
            return _fetchedResultsController!
        }
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil

    /**
     *  Begin table view updates when fetched results controller wants to change datasource.
     */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    /**
     *  Change content of table view when fetched results controller is making changes to the datasource.
     */
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case NSFetchedResultsChangeInsert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case NSFetchedResultsChangeDelete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            break
        }
    }

    /**
     *  Change content of table view when fetched results controller is making changes to the datasource.
     */
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        var tableView = self.tableView
        
        switch type {
        case NSFetchedResultsChangeInsert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case NSFetchedResultsChangeDelete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case NSFetchedResultsChangeUpdate:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath), atIndexPath: indexPath)
        case NSFetchedResultsChangeMove:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        default:
            break
        }
    }

    /**
     *  End table view updates when fetched results controller finished changeing datasource.
     */
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    /**
     *  Configure UITableViewCell content that will be displayed at specified index path.
     *
     *  @param cell      UITableViewCell that needs to be configured.
     *  @param indexPath index path at which the cell will be displayed.
     */
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let paymentCell = cell as? SEPaymentTableViewCell {
            var payment = self.fetchedResultsController.objectAtIndexPath(indexPath) as SEPayment
            paymentCell.clientLabel.text = payment.clientNameC
            paymentCell.amountLabel.text = "$\(payment.paymentAmountC).00"
            paymentCell.jobLabel.text = payment.jobNameC
            
            var statusImageName = payment.statusC == "Complete" ? "icon_status_small_active" : "icon_status_small"
            paymentCell.paymentStatusImage.image = UIImage(named: statusImageName)
            
            var df = NSDateFormatter()
            df.timeStyle = .NoStyle
            df.dateStyle = .MediumStyle
            paymentCell.dateLabel.text = df.stringFromDate(payment.paymentDateC).uppercaseString
            
            paymentCell.bottomCellView.backgroundColor = UIColor(red: 0.85, green: 0.109, blue: 0.36, alpha: 1)
        }
    }

    /**
     *  Pass selected object to next view controller if it needs it.
     *
     *  @param segue  segue that will occur
     *  @param sender object that begin the segue
     */
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if let vc = segue.destinationViewController as? SEPaymentViewController {
            if let cell = sender as? UITableViewCell {
                var indexPath = self.tableView.indexPathForCell(cell)
                var payment = self.fetchedResultsController.objectAtIndexPath(indexPath) as SEPayment
                vc.payment = payment
            }
        }
    }

}
