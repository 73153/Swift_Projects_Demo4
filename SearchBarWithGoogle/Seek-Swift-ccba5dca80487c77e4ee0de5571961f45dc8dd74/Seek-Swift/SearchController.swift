//
//  ViewController.swift
//  Seek-Swift
//
//  Created by Jamie Smith on 6/5/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

import UIKit

class SearchController: RootViewController {
    
    @IBOutlet var collectionView: UICollectionView
    @IBOutlet var textField: UITextField
    
    @lazy var api = AutocompleteAPI()
    var suggestions = String[]()
    
    // Setup
    // ----------------------------------
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController.navigationBarHidden = true
        registerForKeyboardNotifications()
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        navigationController.delegate = self
    }
    
    func setupViews() {
        textField.tintColor = Appearance.blueColor
        textField.textColor = Appearance.blueColor
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
        textField.resignFirstResponder()
    }
    
    // Helpers
    // ----------------------------------
    func displaySuggestionsForText(text: String) {
        api.suggestionsForQuery(text) { response in
            
            switch response {
            case .Error(let error):
                self.handleError(error)
            case .Results(let results):
                self.suggestions = results
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func handleError(error: NSError!) {
        let errorCode = error.code

        switch errorCode {
            case ( NSError.cancelledRequestCode() ):
                break
            default:
                println(error)
        }
    }
    
    func showSearchResultsWithQuery(query: String) {
        let resultsController = WebResultsController.resultsControllerWithQuery(query)
        navigationController.pushViewController(resultsController, animated: true)
    }
}

extension SearchController: UITextFieldDelegate {
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        var newText = textField.text as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        
        if (newText.length > 0) {
            displaySuggestionsForText(newText)
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        showSearchResultsWithQuery(textField.text)
        return true
    }
}

extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Data Source
    // ----------------------------------
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!  {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SuggestionCell", forIndexPath: indexPath) as SuggestionCell
        cell.configureForSuggestion(suggestions[indexPath.item])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int  {
        return suggestions.count
    }
    
    // Delegate
    // ----------------------------------
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        let query = suggestions[indexPath.item]
        showSearchResultsWithQuery(query)
    }
}

// Extends the UICollectionView's scroll view
// to automatically resize its content inset when
// the keyboard appears
extension SearchController {
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo[UIKeyboardFrameEndUserInfoKey].CGRectValue()
        collectionView.contentInset.bottom = frameCoveredByKeyboard(keyboardFrame: keyboardFrame).height
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    func frameCoveredByKeyboard(#keyboardFrame: CGRect) -> CGRect {
        let ourFrameInWindowCoordinates = collectionView.window.convertRect(collectionView.frame, fromView: collectionView.superview)
        var frameCoveredByKeyboard = CGRectIntersection(ourFrameInWindowCoordinates, keyboardFrame)
        return collectionView.window.convertRect(frameCoveredByKeyboard, toView: collectionView.superview)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        collectionView.contentInset = UIEdgeInsetsZero
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
}
