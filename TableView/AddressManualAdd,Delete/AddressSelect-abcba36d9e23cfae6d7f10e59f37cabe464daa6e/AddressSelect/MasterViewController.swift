//
//  MasterViewController.swift
//  AddressSelect
//
//  Created by Yoel R. GARCIA DIAZ on 10/06/2014.
//  Copyright (c) 2014 YRGD. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

/*
extension NSManagedObject {
	var name : String {
	get {
		return self.name
	}
	set {
		self.name = newValue
	}
	}
	var searchString : String {
	get {
		return self.searchString
	}
	set {
		self.searchString = newValue
	}
	}
	var placemark : CLPlacemark {
	get {
		return self.placemark
	}
	set {
		self.placemark = newValue
	}
	}
	var timeStamp : NSDate {
	get {
		return self.timeStamp
	}
	set {
		self.timeStamp = newValue
	}
	}
}
*/

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, AddressEntryDelegate {

	var managedObjectContext: NSManagedObjectContext? = nil

	struct StopPoint {
		let Revealed = CGPointMake(0, -64)
		let Default = CGPointMake(0, 66)
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem()

		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showAddressEntryView:")
		self.navigationItem.rightBarButtonItem = addButton
		self.tableView.contentInset = UIEdgeInsetsMake(-130, 0, 0, 0)
		
		(self.tableView.tableHeaderView as APAddressEntryView).delegate = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func showAddressEntryView(sender: UIBarButtonItem) {
		
	}
	
	// pragme mark - AddressEntryDelegate
	
	func insertNewAddress(newAddress address: APAddress) {
		insertNewObject(address)
	}

	func insertNewObject(address: APAddress) {
		let context = self.fetchedResultsController.managedObjectContext
		let entity = self.fetchedResultsController.fetchRequest.entity
		let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name, inManagedObjectContext: context) as NSManagedObject
		     
		// If appropriate, configure the new managed object.
		// Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
		
		newManagedObject.name = address.name
		newManagedObject.placemark = address.placemark!
		newManagedObject.searchString = address.searchString
		newManagedObject.timeStamp = NSDate.date()
		     
		// Save the context.
		var error: NSError? = nil
		if !context.save(&error) {
		    // Replace this implementation with code to handle the error appropriately.
		    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		    //println("Unresolved error \(error), \(error.userInfo)")
		    abort()
		}
	}

	// #pragma mark - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
		    let indexPath = self.tableView.indexPathForSelectedRow()
		    let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
		    (segue.destinationViewController as DetailViewController).detailAddress = APAddress.addressFromManagedObject(object: object)
		}
	}
	
	//
	
	func configureContentInset(scrollView: UIScrollView) {
		let topInset: CGFloat = scrollView.contentInset.top < 0 ? 64.0 : -66.0;
		scrollView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
		if (topInset == -66) {
			let centre = NSNotificationCenter.defaultCenter()
			centre.postNotificationName("AddressViewDidHide", object: nil)
		}
		
	}
	
	// #pragma mark - Scroll View Delegate
	
	override func scrollViewWillEndDragging(scrollView: UIScrollView!, withVelocity velocity: CGPoint, targetContentOffset: CMutablePointer<CGPoint>) {
		if scrollView == self.tableView {
			var stopPoint: CGPoint? = nil
			if scrollView.contentInset.top < 0 &&  -scrollView.contentOffset.y > 5 {
				stopPoint = StopPoint().Revealed
			} else if (scrollView.contentInset.top > 0 && scrollView.contentOffset.y > -30) {
				stopPoint = StopPoint().Default
			} else { return }
			
			UnsafePointer<CGPoint>(targetContentOffset).memory.y = stopPoint!.y
			
			UIView .animateWithDuration(0.3,
				delay: 0.0,
				usingSpringWithDamping: 1.0,
				initialSpringVelocity: velocity.y,
				options: nil,
				animations: { () -> Void in
					self.tableView.contentOffset = stopPoint!
				},
				completion: { (finished: Bool) -> Void in
					self.configureContentInset(scrollView)
				}
			)
		}
	}

	// #pragma mark - Table View
	
	override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
		return 64
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.fetchedResultsController.sections.count
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = self.fetchedResultsController.sections[section] as NSFetchedResultsSectionInfo
		return sectionInfo.numberOfObjects
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
		self.configureCell(cell, atIndexPath: indexPath)
		return cell
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
		    let context = self.fetchedResultsController.managedObjectContext
		    context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
		        
		    var error: NSError? = nil
		    if !context.save(&error) {
		        // Replace this implementation with code to handle the error appropriately.
		        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		        //println("Unresolved error \(error), \(error.userInfo)")
		        abort()
		    }
		}
	}

	func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
		let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
		let address = APAddress.addressFromManagedObject(object: object)
		(cell.contentView.viewWithTag(10) as UILabel).text = object.name.capitalizedString
		(cell.contentView.viewWithTag(20) as UILabel).text = address .lines(twoLines: true)
	}

	// #pragma mark - Fetched results controller

	var fetchedResultsController: NSFetchedResultsController {
	    if _fetchedResultsController != nil {
	        return _fetchedResultsController!
	    }
	    
	    let fetchRequest = NSFetchRequest()
	    // Edit the entity name as appropriate.
	    let entity = NSEntityDescription.entityForName("Address", inManagedObjectContext: self.managedObjectContext)
	    fetchRequest.entity = entity
	    
	    // Set the batch size to a suitable number.
	    fetchRequest.fetchBatchSize = 20
	    
	    // Edit the sort key as appropriate.
	    let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
	    let sortDescriptors = [sortDescriptor]
	    
	    fetchRequest.sortDescriptors = [sortDescriptor]
	    
	    // Edit the section name key path and cache name if appropriate.
	    // nil for section name key path means "no sections".
	    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
	    aFetchedResultsController.delegate = self
	    _fetchedResultsController = aFetchedResultsController
	    
		var error: NSError? = nil
		if !_fetchedResultsController!.performFetch(&error) {
		     // Replace this implementation with code to handle the error appropriately.
		     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	         //println("Unresolved error \(error), \(error.userInfo)")
		     abort()
		}
	    
	    return _fetchedResultsController!
	}    
	var _fetchedResultsController: NSFetchedResultsController? = nil

	func controllerWillChangeContent(controller: NSFetchedResultsController) {
	    self.tableView.beginUpdates()
	}

	func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
	    switch type {
	        case NSFetchedResultsChangeInsert:
	            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
	        case NSFetchedResultsChangeDelete:
	            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
	        default:
	            return
	    }
	}

	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
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
	            return
	    }
	}

	func controllerDidChangeContent(controller: NSFetchedResultsController) {
	    self.tableView.endUpdates()
	}

	/*
	 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
	 
	 func controllerDidChangeContent(controller: NSFetchedResultsController) {
	     // In the simplest, most efficient, case, reload the table view.
	     self.tableView.reloadData()
	 }
	 */

}

