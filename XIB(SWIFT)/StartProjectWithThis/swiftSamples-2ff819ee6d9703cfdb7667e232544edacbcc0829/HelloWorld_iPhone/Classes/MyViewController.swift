//
//  NewMyViewController.swift
//  HelloWorld
//
//  Created by Calman Steynberg on 2014-06-03.
//
//

import UIKit

class MyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textField: UITextField!
    @IBOutlet var label: UILabel!
    var string: String?

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // When the user starts typing, show the clear button in the text field.
        self.textField.clearButtonMode = UITextFieldViewMode.WhileEditing

        // When the view first loads, display the placeholder text that's in the
        // text field in the label.
        self.label.text = textField.placeholder

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldReturn(textField: UITextField?) -> Bool {
        // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
        if (textField === self.textField) {
            self.textField.resignFirstResponder()
            // Invoke the method that changes the greeting.
            self.updateString()
        }
        
        return true
    }
    

    func updateString() {
        // Store the text of the text field in the 'string' instance variable.
        self.string = self.textField.text;
        // Set the text of the label to the value of the 'string' instance variable.
        self.label.text = self.string;
    
    }

    override func touchesBegan(touches: NSSet!,
        withEvent event: UIEvent!) {
        // Dismiss the keyboard when the view outside the text field is touched.
        self.textField.resignFirstResponder()
        
        // Revert the text field to the previous value.
        self.textField.text = self.string;

    }


}
