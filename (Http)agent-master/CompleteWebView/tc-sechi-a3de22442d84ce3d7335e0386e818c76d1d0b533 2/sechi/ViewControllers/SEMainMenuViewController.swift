//
//  SEMainMenuViewController.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-14.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  View controller used for displaying application main menu.
 */
class SEMainMenuViewController: SEViewController {

    /**
     *  Custom enum type for indicating user status.
     */
    enum SEUserStatus: Int {
        case Available = 0, Transit, Working, DND
    }

    /**
     *  Top NSLayoutConstraint of the logo image
     */
    @IBOutlet var logoImageTopMarginConstraint: NSLayoutConstraint

    /**
     *  Bottom NSLayoutConstraint of the logo image
     */
    @IBOutlet var logoImageBottomMarginConstraint: NSLayoutConstraint

    /**
     *  Top NSLayoutConstraint of the main menu
     */
    @IBOutlet var mainMenuTopMarginConstraint: NSLayoutConstraint

    /**
     *  Group of buttons used as app main menu
     */
    @IBOutlet var mainMenu: UIView

    /**
     *  Gesture recognizer that selectes current user status
     */
    var selectStatusGestureRecognizer: UITapGestureRecognizer!
    /**
     *  View grouping status indicators
     */
    @IBOutlet var selectStatusView: UIView
    /**
     *  Status available indicator view
     */
    @IBOutlet var statusAvailableView: UIView
    /**
     *  Status trainsit indicator view
     */
    @IBOutlet var statusTransitView: UIView
    /**
     *  Status working indicator view
     */
    @IBOutlet var statusWorkingView: UIView
    /**
     *  Status DND indicator view
     */
    @IBOutlet var statusDNDView: UIView

    /**
     *  Status Available indicator image view
     */
    @IBOutlet var statusAvailableImageView: UIImageView
    /**
     *  Status Transit indicator image view
     */
    @IBOutlet var statusTransitImageView: UIImageView
    /**
     *  Status working indicator image view
     */
    @IBOutlet var statusWorkingImageView: UIImageView
    /**
     *  Status DND indicator image view
     */
    @IBOutlet var statusDNDImageView: UIImageView

    /**
     *  Setup gesture recognizer on status indicator views, fix ui for four inch screens. Sets last used status as active.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if HAS_4_INCH_SCREEN {
            self.logoImageTopMarginConstraint.constant = 90.0
            self.logoImageBottomMarginConstraint.constant = 30.0
        } else {
            self.logoImageTopMarginConstraint.constant = 30.0
            self.logoImageBottomMarginConstraint.constant = 10.0
        }
        
        self.setMainMenuVisible(false, animated: false)
        self.selectStatusGestureRecognizer = UITapGestureRecognizer(target: self, action: "selectStatusAreaTouched:")
        
        self.selectStatusView.addGestureRecognizer(self.selectStatusGestureRecognizer)
        
        var userStatusRaw: Int = NSUserDefaults.standardUserDefaults().objectForKey(SEUserDefaultsUserStatusKey) as Int
        self.setActiveStatus(SEUserStatus.fromRaw(userStatusRaw)!)
    }

    /**
     *  Sets navigation bar visibility
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController.setNavigationBarHidden(true, animated: animated)
    }

    /**
     *  Displays main menu if it's hidden.
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.mainMenu.alpha == 0.0 {
            self.setMainMenuVisible(true, animated: true)
        }
    }

    /**
     *  Decides which status was tapped by a user by touch location, then sets this status as active.
     *
     *  @param gestureRecognizer gesture recognizer that recognized a tap
     */
    func selectStatusAreaTouched(gestureRecognizer: UITapGestureRecognizer) {
        if CGRectContainsPoint(self.statusAvailableView.frame, gestureRecognizer.locationInView(self.selectStatusView)) {
            self.setActiveStatus(.Available)
        } else if CGRectContainsPoint(self.statusTransitView.frame, gestureRecognizer.locationInView(self.selectStatusView)) {
            self.setActiveStatus(.Transit)
        } else if CGRectContainsPoint(self.statusWorkingView.frame, gestureRecognizer.locationInView(self.selectStatusView)) {
            self.setActiveStatus(.Working)
        } else if CGRectContainsPoint(self.statusDNDView.frame, gestureRecognizer.locationInView(self.selectStatusView)) {
            self.setActiveStatus(.DND)
        }
    }

    /**
     *  Sets active status indicator for specified status
     *
     *  @param userStatus SEUserStatus that should be marked as active.
     */
    func setActiveStatus(userStatus: SEUserStatus) {
        var activeImageView: UIImageView?
        switch userStatus {
            case .Available:
                activeImageView = self.statusAvailableImageView
            case .Transit:
                activeImageView = self.statusTransitImageView
            case .Working:
                activeImageView = self.statusWorkingImageView
            case .DND:
                activeImageView = self.statusDNDImageView
        }
        
        if activeImageView {
            // reset all images to non active
            for imageView in [self.statusAvailableImageView, self.statusTransitImageView, self.statusWorkingImageView, self.statusDNDImageView] {
                imageView.image = UIImage(named: "icon_status.png")
            }
            
            activeImageView!.image = UIImage(named: "icon_status_active.png")
            
            NSUserDefaults.standardUserDefaults().setObject(userStatus.toRaw(), forKey: SEUserDefaultsUserStatusKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    /**
     *  setMainMenuVisible:animated:completion: alias without completion handler
     *
     *  @param visible
     *  @param animated
     */
    func setMainMenuVisible(visible: Bool, animated: Bool) {
        self.setMainMenuVisible(visible, animated: animated, completion: nil)
    }

    /**
     *  Sets Main menu buttons visibility with completion handler
     *
     *  @param visible    should views be shown or hidden
     *  @param animated   should the change be animated or not
     *  @param completion completion handler to run after view properies change
     */
    func setMainMenuVisible(visible: Bool, animated: Bool, completion: ((Bool) -> Void)?) {
        var topMarginDelta: Float = 50.0
        var newMainMenuTopConstraintConstant = self.mainMenuTopMarginConstraint.constant
        
        if visible {
            newMainMenuTopConstraintConstant += topMarginDelta
        } else {
            newMainMenuTopConstraintConstant -= topMarginDelta
        }
        
        var actionsBlock = {
            () -> Void in
            self.mainMenu.alpha = visible ? 1.0 : 0.0
            self.mainMenuTopMarginConstraint.constant = newMainMenuTopConstraintConstant
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animateWithDuration(visible ? 0.3 : 0.2, animations: actionsBlock, completion: completion)
        } else {
            actionsBlock()
            if completion != nil {
                completion!(true)
            }
        }
    }

}
