//
//  SEPartsViewController.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-14.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  View controller used for displaying list of part objects (products).
 */
class SEPartsViewController: SEViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UISearchBarDelegate, SEProductsScannerViewControllerDelegate {

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
     *  UISearchBar object that's used to search objects in table view.
     */
    @IBOutlet var searchBar: UISearchBar

    /**
     *  Setup views properties and initiates displayed objects sync.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.managedObjectContext = SERestClient.instance.managedObjectContext
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(68, 0, 0, 0)
        self.searchBar.delegate = self
        self.searchBar.tintColor = UIColor.whiteColor()
        
        SERestClient.instance.refreshPartsList()
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
        self.performSegueWithIdentifier(SEPushModalProductCodeReaderViewControllerSegue, sender: self)
    }

    /**
     *  Display product code scanner view controller.
     */
    func showProductCodeScannerController() {
        self.performSegueWithIdentifier(SEPushModalProductCodeReaderViewControllerSegue, sender: nil)
    }

    /**
     *  Update data from API if search button was clicked.
     */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        SERestClient.instance.refreshPartsList()
        searchBar.resignFirstResponder()
    }

    /**
     *  Update data from API if cancel button was clicked.
     */
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        SERestClient.instance.refreshPartsList()
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
        var cell = tableView.dequeueReusableCellWithIdentifier(SEProductTableViewCellIdentifier) as UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    /**
     *  Fetched results controller used to retrive content for table view.
     */
    var fetchedResultsController: NSFetchedResultsController {
        get {
            if _fetchedResultsController {
                return _fetchedResultsController!
            }
            
            var fetchRequest = NSFetchRequest()
            var entity = NSEntityDescription.entityForName("SEProduct", inManagedObjectContext: self.managedObjectContext)
            fetchRequest.entity = entity
            fetchRequest.fetchBatchSize = 20
            var sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
            var predicate = NSPredicate(format: "NOT (removed LIKE %@)", "true")

            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = predicate
            _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            _fetchedResultsController!.delegate = self
            
            var error: NSError? = nil;
            if !_fetchedResultsController!.performFetch(&error) {
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
                break;
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
        if let productCell = cell as? SEProductTableViewCell {
            var product = self.fetchedResultsController.objectAtIndexPath(indexPath) as SEProduct
            productCell.productName.text = product.name
            productCell.productCode.text = product.productcode
        }
    }

    /**
     *  Set self as SEProductsScannerViewController if it's going to be displayed.
     *
     *  @param segue  segue that will occur
     *  @param sender object that begin the segue
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        if segue.identifier == SEPushModalProductCodeReaderViewControllerSegue {
            var psvc = segue.destinationViewController as SEProductsScannerViewController
            psvc.delegate = self
        }

    }

    /**
     *  Dismiss SEProductsScannerViewController if it canceled reading the codes.
     *
     *  @param productsScannerViewController that wants to be dismissed
     */
    func productsScannerViewControllerDidCancelReading(productsScannerViewController: SEProductsScannerViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /**
     *  Dismiss SEProductsScannerViewController and set the content that it read as the value of the search bar.
     *
     *  @param productsScannerViewController SEProductsScannerViewController that read the metadata
     *  @param string                        metadata decoded to string
     */
    func productsScannerViewController(productsScannerViewController: SEProductsScannerViewController, didReadString string: String) {
        self.dismissViewControllerAnimated(true) {
            self.searchBar.text = string
            self.tableView.reloadData()
        }
    }

}
