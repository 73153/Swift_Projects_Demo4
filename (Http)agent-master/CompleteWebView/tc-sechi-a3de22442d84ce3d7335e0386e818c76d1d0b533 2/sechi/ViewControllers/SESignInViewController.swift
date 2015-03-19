//
//  SESignInViewController.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-14.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import UIKit

/**
 *  View controller used for signing in a user.
 */
@objc
class SESignInViewController: SEViewController, UITextFieldDelegate {

    /**
     *  Top logo image NSLayoutConstraint
     */
    @IBOutlet var logoImageTopMarginConstraint: NSLayoutConstraint

    /**
     *  Top NSLayoutConstraint of group of form items (text fields and signup button)
     */
    @IBOutlet var signInControlsGroupTopConstraint: NSLayoutConstraint

    /**
     *  View that's grouping sign in controls (text fields and signup button)
     */
    @IBOutlet var signInControlsGroup: UIView

    /**
     *  Text field for username
     */
    @IBOutlet var usernameTextField: SETextField

    /**
     *  Text field for password
     */
    @IBOutlet var passwordTextField: SETextField

    /**
     *  Top NSLayoutConstraint of activity indicator
     */
    @IBOutlet var activityIndicatorTopConstraint: NSLayoutConstraint

    /**
     *  ActivityIndicator used to indicate loading / signing up phase
     */
    @IBOutlet var activityIndicator: UIActivityIndicatorView

    /**
     *  Set views visibility, updates UI for 4 inch screens, sets views properies
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setActivityIndicatorVisible(false, animated: false)
        self.setSignInControlsGroupVisible(false, animated: false)
        
        if HAS_4_INCH_SCREEN {
            self.logoImageTopMarginConstraint.constant = 90.0
        } else {
            self.logoImageTopMarginConstraint.constant = 30.0
        }
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    /**
     *  Setups navigation bar visibility
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController.setNavigationBarHidden(true, animated: animated)
    }

    /**
     *  Sets sign in controls visible
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setSignInControlsGroupVisible(true, animated: true)
    }

    /**
     *  Hides all controls of the view after it disappears.
     */
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.setSignInControlsGroupVisible(false, animated: false)
        self.setActivityIndicatorVisible(false, animated: false)
    }

    /**
     *  Simulate signup process, displays activity indicator, and pushes main menu view controller after 1.5 sec
     */
    @IBAction func signInButtonTouchedUpInside(sender: UIButton) {
        self.setActivityIndicatorVisible(true, animated: true)
        self.setSignInControlsGroupVisible(false, animated: true) {
            finished in
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC.value)), dispatch_get_main_queue(), {
            () -> Void in
            self.setActivityIndicatorVisible(false, animated: true) {
                finished in
                self.performSegueWithIdentifier(SEPushMainMenuViewControllerSegue, sender:sender)
            }
        })
    }

    /**
     *  setSignInControlsGroupVisible:animated:completion: alias without completion handler
     *
     *  @param visible
     *  @param animated
     */
    func setSignInControlsGroupVisible(visible: Bool, animated: Bool) {
        self.setSignInControlsGroupVisible(visible, animated: animated, completion: nil)
    }

    /**
     *  Sets the sign in controls visibility with completition handler
     *
     *  @param visible    should controls be shown or hidden
     *  @param animated   should the change be animated
     *  @param completion completion block, runned after changeing view attributes
     */
    func setSignInControlsGroupVisible(visible: Bool, animated: Bool, completion: ((_: Bool) -> Void)?) {
        var topMarginDelta: Float = 50.0
        var newSignInControlsGroupTopConstraintConstant = self.signInControlsGroupTopConstraint.constant
        
        if visible {
            newSignInControlsGroupTopConstraintConstant -= topMarginDelta
        } else {
            newSignInControlsGroupTopConstraintConstant += topMarginDelta
        }
        
        var actionsBlock = {
            () -> Void in
            self.signInControlsGroup.alpha = visible ? 1.0 : 0.0
            self.signInControlsGroupTopConstraint.constant = newSignInControlsGroupTopConstraintConstant
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

    /**
     *  setActivityIndicatorVisible:animated:completion: alias without completion handler
     *
     *  @param visible
     *  @param animated
     */
    func setActivityIndicatorVisible(visible: Bool, animated: Bool) {
        self.setActivityIndicatorVisible(visible, animated: animated, completion: nil)
    }

    /**
     *  Sets the activity indicator visibility with completition handler
     *
     *  @param visible    should activity indicator be shown or hidden
     *  @param animated   should the change be animated
     *  @param completion completion block, runned after changeing view attributes
     */
    func setActivityIndicatorVisible(visible: Bool, animated: Bool, completion: ((_: Bool) -> Void)?) {
        var topMarginDelta: Float = 30.0
        var newActivityIndicatorTopConstraintConstant = self.activityIndicatorTopConstraint.constant
        
        if visible {
            newActivityIndicatorTopConstraintConstant += topMarginDelta
            self.activityIndicator.startAnimating()
        } else {
            newActivityIndicatorTopConstraintConstant -= topMarginDelta
            self.activityIndicator.stopAnimating()
        }
        
        var actionsBlock = {
            () -> Void in
            self.activityIndicator.alpha = visible ? 1.0 : 0.0
            self.activityIndicatorTopConstraint.constant = newActivityIndicatorTopConstraintConstant
            self.view.layoutIfNeeded()
        };
        
        if animated {
            UIView.animateWithDuration(visible ? 0.3 : 0.2, animations: actionsBlock, completion: completion)
        } else {
            actionsBlock()
            if completion != nil {
                completion!(true)
            }
        }
    }

    //#pragma mark - UITextFieldDelegate
    /**
     *  Hide keyboard on text field return
     *
     *  @param textField text field that wants to return
     *
     *  @return BOOL disallowing textfield return
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
