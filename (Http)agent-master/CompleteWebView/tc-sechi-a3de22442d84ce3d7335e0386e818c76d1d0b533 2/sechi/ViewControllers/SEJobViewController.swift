//
//  SEJobViewController.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  View controller used to display single job object.
 */
class SEJobViewController: SEViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, SESwipeableTableViewCellDelegate, UIGestureRecognizerDelegate {

    /**
     *  SEJob object to display.
     */
    var job: SEJob!

    /**
     *  UITableView used to display object info.
     */
    @IBOutlet var tableView: UITableView

    /**
     *  Datasource with UITableViewCell identifiers used to display info.
     */
    var datasource: String[]!

    /**
     *  Temporary cell objects used to calculate cell height.
     */
    var tempClientInfoCell: SEJobClientInfoTableViewCell!
    var tempAddressInfoCell: SEJobAddressTableViewCell!
    var tempNotesInfoCell: SEJobNotesTableViewCell!

    /**
     *  Index path of cell that began process of removing (swipe, press delete button etc).
     */
    var indexPathToRemove: NSIndexPath?

    /**
     *  Gesture recognizer used to cancel the custom edit mode of the table view.
     */
    var editModeGestureRecognizer: UIPanGestureRecognizer!

    /**
     *  Setup table view properties and cells that will be displayed. Prepare temporary cells for use.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.datasource = [SEJobClientInfoTableViewCellIdentifier, SEJobAddressTableViewCellIdentifier, SEJobNotesTableViewCellIdentifier, SEJobPhotosTableViewCellIdentifier, SEJobHoursTableViewCellIdentifier]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(74, 0, 0, 0)

        self.tempClientInfoCell = self.tableView.dequeueReusableCellWithIdentifier(SEJobClientInfoTableViewCellIdentifier) as SEJobClientInfoTableViewCell
        self.tempAddressInfoCell = self.tableView.dequeueReusableCellWithIdentifier(SEJobAddressTableViewCellIdentifier) as SEJobAddressTableViewCell
        self.tempNotesInfoCell = self.tableView.dequeueReusableCellWithIdentifier(SEJobNotesTableViewCellIdentifier) as SEJobNotesTableViewCell
        
        self.editModeGestureRecognizer = UIPanGestureRecognizer(target: self, action: "viewWasPanned:")
        self.view.addGestureRecognizer(self.editModeGestureRecognizer)
        self.editModeGestureRecognizer.delegate = self
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
     *  @param cell SESwipeableCell that was opened.
     */
    func cellDidOpen(cell: SESwipeableTableViewCell) {
        var newIndexPathToRemove = self.tableView.indexPathForCell(cell)
        
        if self.indexPathToRemove != newIndexPathToRemove {
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
     *  Basic setup of UITableView with NSFetchedResultsViewController
     */
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
        var cell = tableView.dequeueReusableCellWithIdentifier(self.datasource[indexPath.row]) as UITableViewCell
        
        if let swipeableCell = cell as? SESwipeableTableViewCell {
            swipeableCell.delegate = self
        }
        
        if let clientInfoCell = cell as? SEJobClientInfoTableViewCell {
            clientInfoCell.clientLabel.text = self.job.clientNameC
            clientInfoCell.contactLabel.text = self.job.contactNameC
            clientInfoCell.phoneLabel.text = self.job.phoneC
            clientInfoCell.infoTextView.text = self.job.infoTextC
            clientInfoCell.infoTextView.font = TextFieldFont
            clientInfoCell.infoTextView.contentInset = UIEdgeInsetsMake(-8, -4, 0, 0)
            clientInfoCell.infoTextView.userInteractionEnabled = false
            clientInfoCell.bottomCellView.backgroundColor = UIColor(red: 0.137, green: 0.121, blue: 0.125, alpha: 1)
            clientInfoCell.callButton.addTarget(self, action: "callButtonTouchedUpInside:", forControlEvents: .TouchUpInside)
        } else if let addressCell = cell as? SEJobAddressTableViewCell {
            addressCell.addressLabel.text = self.job.jobAddressC
            addressCell.addressLabel.font = TextFieldFont
            addressCell.addressLabel.contentInset = UIEdgeInsetsMake(-8, -4, 0, 0)
            addressCell.addressLabel.userInteractionEnabled = false
            addressCell.bottomCellView.backgroundColor = UIColor(red: 0.137, green: 0.121, blue: 0.125, alpha: 1)
        } else if let notesCell = cell as? SEJobNotesTableViewCell {
            notesCell.notesLabel.text = self.job.notesC
            notesCell.notesLabel.font = TextFieldFont
            notesCell.notesLabel.contentInset = UIEdgeInsetsMake(-8, -4, 0, 0)
            notesCell.notesLabel.userInteractionEnabled = false
        } else if let photosCell = cell as? SEJobPhotosTableViewCell {
            photosCell.datasource = self.job.photos
            photosCell.collectionView.delegate = self
            photosCell.collectionView.reloadData()
        } else if let hoursCell = cell as? SEJobHoursTableViewCell {
            hoursCell.hoursLabel.text = "00:00:00"
            hoursCell.startButton.hidden = false
            hoursCell.completeButton.hidden = false
            
            var dc = NSDateComponents()
            dc.hour = 0
            dc.minute = 0
            dc.second = 0
            
            if self.job.statusC == "In Progress" {
                hoursCell.startButton.hidden = true
                var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
                dc = calendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond, fromDate: self.job.jobStartTimeC, toDate: NSDate.date(), options: nil)
            } else if self.job.statusC == "Complete" {
                hoursCell.startButton.hidden = true
                hoursCell.completeButton.hidden = true
                var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
                dc = calendar.components(NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond, fromDate:self.job.jobStartTimeC, toDate: self.job.jobEndTimeC, options: nil)
            }
            
            var hours = dc.hour < 10 ? "0\(dc.hour)" : "\(dc.hour)"
            var minutes = dc.minute < 10 ? "0\(dc.minute)" : "\(dc.minute)"
            var seconds = dc.second < 10 ? "0\(dc.second)" : "\(dc.second)"
            
            hoursCell.hoursLabel.text = "\(hours):\(minutes):\(seconds)"
            
            hoursCell.startButton.addTarget(self, action: "startButtonTouchedUpInside:", forControlEvents: .TouchUpInside)
            hoursCell.completeButton.addTarget(self, action: "completeButtonTouchedUpInside:", forControlEvents: .TouchUpInside)
        }
        
        return cell
    }

    /**
     *  Initiate phone dialer with number from object property
     *
     *  @param sender object that called the method
     */
    func callButtonTouchedUpInside(sender: UIButton) {
        var phone = self.job.phoneC.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).bridgeToObjectiveC().componentsJoinedByString("")
        var callUrl = NSURL(string: "tel:\(phone)")
        
        if UIApplication.sharedApplication().canOpenURL(callUrl) {
            UIApplication.sharedApplication().openURL(callUrl)
        }
        else {
            UIAlertView(title: "Error", message: "This function is only available on the iPhone", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }

    /**
     *  Updates objects status, its start date and dismisses view controller
     *
     *  @param sender object that called the method
     */
    func startButtonTouchedUpInside(sender: UIButton) {
        var error: NSError? = nil
        self.job.jobStartTimeC = NSDate.date()
        self.job.statusC = "In Progress";
        self.job.managedObjectContext.save(&error)
        if error {
            NSLog("%@", error!)
        } else {
            self.job.managedObjectContext.saveToPersistentStore(&error)
            if error {
                NSLog("%@", error!)
            }
        }
        
        self.navigationController.popViewControllerAnimated(true)
    }

    /**
     *  Updates objects status, its end date and dismisses view controller.
     *
     *  @param sender object that called the method
     */
    func completeButtonTouchedUpInside(sender: UIButton) {
        self.job.statusC = "Complete"
        self.job.jobEndTimeC = NSDate.date()
        
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
        
        self.navigationController.popViewControllerAnimated(true)
    }

    /**
     *  Display gallery view controller or image picker when photo from collection view was selected, or add button was pressed
     *
     *  @param collectionView collection view where event occured
     *  @param indexPath      index path of view that was selected
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            self.selectPhoto()
        } else {
            var gallery = SEGalleryViewController(mediaFilesArray: self.job.photos, atIndex: indexPath.row - 1)
            self.navigationController.pushViewController(gallery, animated: true)
        }
        
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
        switch (indexPath.row) {
            case 0:
                self.tempClientInfoCell.clientLabel.text = self.job.clientNameC
                self.tempClientInfoCell.contactLabel.text = self.job.contactNameC
                self.tempClientInfoCell.phoneLabel.text = self.job.phoneC
                self.tempClientInfoCell.infoTextView.text = self.job.infoTextC
                return self.tempClientInfoCell.cellHeightNeeded()
            case 1:
                self.tempAddressInfoCell.addressLabel.text = self.job.jobAddressC
                return self.tempAddressInfoCell.cellHeightNeeded()
            case 2:
                self.tempNotesInfoCell.notesLabel.text = self.job.notesC
                return self.tempNotesInfoCell.cellHeightNeeded()
            case 3:
                return 63.0
            case 4:
                return 100.0
            default:
                return 44.0
        }
    }

    /**
     *  Method decides to show image picker, camera view controller or if both are available ask a user what do he want to do.
     */
    func selectPhoto() {
        var a = UIImagePickerController.isSourceTypeAvailable(.Camera)
        var b = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
        
        if a && b {
            var alertView = UIAlertView(title: "Add Photo", message: "Select source:", delegate: self, cancelButtonTitle: nil)
            alertView.addButtonWithTitle("Photo library")
            alertView.addButtonWithTitle("Camera")
            alertView.show()
        } else if a && !b {
            self.startCameraControllerFromViewController(self, withCameraCaptureMode: .Photo, usingDelegate: self)
        } else if !a && b {
            self.startMediaBrowserFromViewController(self, photos: true, videos: false, usingDelegate: self)
        } else {
            UIAlertView(title: "Error", message: "No sources available", delegate: self, cancelButtonTitle: "OK").show()
        }
    }

    /**
     *  Pushes selected by user view controller (image picker or camera controller)
     *
     *  @param alertView   alert view with question
     *  @param buttonIndex button index that was pressed
     */
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            if buttonIndex == 0 {
                self.startMediaBrowserFromViewController(self, photos: true, videos: false, usingDelegate: self)
            } else if buttonIndex == 1 {
                self.startCameraControllerFromViewController(self, withCameraCaptureMode: .Photo, usingDelegate: self)
            }
        }
    }

    /**
     *  Displays UIImagePicker
     *
     *  @param controller        controller which initiated the image picker
     *  @param cameraCaptureMode cameraCaputreModes that are allowed
     *
     *  @return YES if image picker was displayed successfully
     */
    func startCameraControllerFromViewController(controller: UIViewController, withCameraCaptureMode cameraCaptureMode: UIImagePickerControllerCameraCaptureMode, usingDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool {
        // check args
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            return false
        }
        
        // init picker
        var cameraUI = SENoStatusBarImagePickerController()
        cameraUI.sourceType = .Camera
        
        
        // filter media types
        var mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.Camera)
        
        if cameraCaptureMode == .Photo {
            mediaTypes = mediaTypes.bridgeToObjectiveC().filteredArrayUsingPredicate(NSPredicate(format: "(SELF contains image)"))
        } else {
            mediaTypes = mediaTypes.bridgeToObjectiveC().filteredArrayUsingPredicate(NSPredicate(format: "(SELF contains movie)"))
        }
        
        // error if not movie/photo is not avaliable
        if mediaTypes.count < 1 {
            UIAlertView(title: "Error occured", message: "Cannot get access to camera.", delegate: self, cancelButtonTitle: "OK").show();
            return false
        }
        
        // finishing setup
        cameraUI.mediaTypes = mediaTypes
        cameraUI.cameraCaptureMode = cameraCaptureMode
        
        cameraUI.allowsEditing = false
        cameraUI.delegate = delegate
        
        // show picker
        controller.presentViewController(cameraUI, animated: true, completion: nil)
        return true
    }

    /**
     *  Displays media browser view controller
     *
     *  @param controller controller which initiated the action
     *  @param showPhotos BOOL, should photos be visible
     *  @param showVideos BOOl, should videos be visible
     *
     *  @return YES if controller was shown, NO otherwise
     */
    func startMediaBrowserFromViewController(controller: UIViewController, photos showPhotos: Bool, videos showVideos: Bool, usingDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
            return false
        }
        
        var mediaUI = SENoStatusBarImagePickerController()
        mediaUI.sourceType = .SavedPhotosAlbum
        
        // Displays saved pictures and movies, if both are available, from the
        // Camera Roll album.
        
        if showPhotos && showVideos {
            mediaUI.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.SavedPhotosAlbum)
        } else if showPhotos {
            mediaUI.mediaTypes = [kUTTypeImage]
        } else if showVideos {
            mediaUI.mediaTypes = [kUTTypeMovie]
        }
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        mediaUI.allowsEditing = false
        
        mediaUI.delegate = delegate
        
        controller.presentViewController(mediaUI, animated: true, completion: nil)
        
        return true
    }

    /**
     *  Method called by UIImagePickerController when user finish picking media
     *
     *  @param picker UIImagePickerController that called the method
     *  @param info   NSDictionary with picked media info
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary) {
        self.dismissViewControllerAnimated(true) {
            () -> () in
            if info.objectForKey(UIImagePickerControllerOriginalImage) {
                var image = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
                image = image.fixOrientation();
                var imageData = UIImageJPEGRepresentation(image, 0.8)

                var uuid = self.uuid();
                var fileName = "\(uuid).jpg"
                var filePath = self.applicationDocumentsDirectory.stringByAppendingPathComponent(fileName)

                imageData.writeToFile(filePath, atomically: true)
            
                var photoInfo = NSEntityDescription.insertNewObjectForEntityForName("SEJobPhotoInfo", inManagedObjectContext:SERestClient.instance.managedObjectContext) as SEJobPhotoInfo
                photoInfo.filePath = filePath
                photoInfo.job = self.job
                                     
                var error: NSError? = nil
                                     
                SERestClient.instance.managedObjectContext.save(&error)
                                     
                if error {
                    UIAlertView(title: "Error", message: "Error occured while saving to database.", delegate: nil, cancelButtonTitle: "OK").show()
                } else {
                    SERestClient.instance.managedObjectContext.saveToPersistentStore(&error)
                                         
                    if error {
                        UIAlertView(title: "Error", message: "Error occured while saving to database.", delegate: nil, cancelButtonTitle: "OK").show()
                    }
                }
                
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            }
        }
    }

    /**
     *  Generates unique id string used for naming a file
     *
     *  @return unique id string
     */
    func uuid() -> String {
        var uuidValue = CFUUIDCreate(kCFAllocatorDefault)
        var uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidValue)
        CFRelease(uuidValue)
        return uuidString
    }

    /**
     *  Returns a path to application documents directiory
     *
     *  @return path to application documents directiory
     */
    var applicationDocumentsDirectory: String {
        get {
            var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as String[]
            return paths[0]
        }
    }

    /**
     *  Returns a path to application caches directiory
     *
     *  @return path to application caches directiory
     */
    var applicationCacheDirectory: String {
        get {
            var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true) as String[]
            return paths[0]
        }
    }

    /**
     *  Forward current object to next view controller if it's able to save it.
     *
     *  @param segue  segue that's going to be performed
     *  @param sender object that initiated the segue
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        if segue.destinationViewController.respondsToSelector("setJob") {
            segue.destinationViewController.setValue(self.job, forKey: "job")
        }
    }

}
