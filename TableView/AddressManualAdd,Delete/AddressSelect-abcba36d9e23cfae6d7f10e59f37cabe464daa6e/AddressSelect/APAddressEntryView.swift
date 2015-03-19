//
//  APAddressEntryView.swift
//  AddressSelect
//
//  Created by Yoel R. GARCIA DIAZ on 10/06/2014.
//  Copyright (c) 2014 YRGD. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddressEntryDelegate {
	func insertNewAddress(newAddress address: APAddress)
}

class APAddressEntryView: UIView, UITextFieldDelegate {
	
	var nameTextField: UITextField? = nil
	var addressTextField: UITextField? = nil
	var resultLabel: UILabel? = nil
	var addButton: UIButton? = nil

	init(coder aDecoder: NSCoder!) {
		super.init(coder: aDecoder)
		if (self != nil) {
			nameTextField = self.viewWithTag(10) as? UITextField
			if let textField = nameTextField {
				textField.delegate = self;
			} else {
				// error: the address name textField is not defined
			}
			addressTextField = self.viewWithTag(20) as? UITextField
			if let textField = self.addressTextField {
				textField.delegate = self;
			} else {
				// error: the address textField is not defined
			}
			resultLabel = self.viewWithTag(30) as? UILabel
			addButton = self.viewWithTag(40) as? UIButton
			if let button = addButton {
				button.addTarget(self, action:"doSomethingCool:", forControlEvents: .TouchUpInside)
			} else {
				// error: the add address button is not defined
			}
			
			let centre = NSNotificationCenter.defaultCenter()
			centre.addObserver(self, selector: "clear", name: "AddressViewDidHide", object: nil)
		}
	}
	
	let geocoder = CLGeocoder()
	var delegate: AddressEntryDelegate? = nil
	var address = APAddress()
	
	func doSomethingCool(sender: UIButton) {
		delegate?.insertNewAddress(newAddress: address)
	}
	
	deinit {
		let centre = NSNotificationCenter.defaultCenter()
		centre.removeObserver(self)
	}
	
	func clear() {
		self.nameTextField!.text = ""
		self.addressTextField!.text = ""
		self.resultLabel!.text = "No Result"
		self.address = APAddress()
		self.addButton!.enabled = false
	}
	
	func textFieldDidBeginEditing(textField: UITextField!) {
		if textField.tag == 20 {
			self.resultLabel!.text = "No Result";
			self.address.placemark = nil
			self.addButton!.enabled = false;
		}
	}
	
	func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
		var trimmedText: NSString
		var wholeText: String
		switch (textField.tag) {
		case 10:
			if string == "" {
				wholeText = textField.text.substringToIndex(range.location)
				trimmedText = wholeText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
			} else {
				wholeText = "\(textField.text)\(string)"
				trimmedText = wholeText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
			}
			self.address.name = trimmedText;
			if (Bool(trimmedText.length) && self.address.placemark) {
				self.addButton!.enabled = true;
			} else { self.addButton!.enabled = false }
			break;
			
		default:
			break;
		}
		return true
	}
	
	func textFieldShouldReturn(textField: UITextField!) -> Bool {
		
		textField.resignFirstResponder()
		
		let trimmedText: NSString = textField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		switch (textField.tag) {
			// The user may 'return' from the nameTextField while there is a valid string in the addressTextField, 
			// this case is not handle in this exercise
			// The user must return from the addressTextField to initiate a search
		case 20:
			// Filter the user's entry to strings with more than two words (including numbers)
			if (Bool(trimmedText.length) && trimmedText.componentsSeparatedByString(" ").count > 2) {
				
				// Call our Geocoder with the trimmed string
				self.geocoder.geocodeAddressString(trimmedText, completionHandler: {
				(placemarks: AnyObject[]!, error: NSError!) -> Void in
					
					if placemarks {
						self.address.placemark = placemarks[0] as? CLPlacemark
						self.resultLabel!.text = self.address.lines(twoLines: true)
						self.address.searchString = trimmedText;
						
						// Enable the add address button only if the user has set an address name
						let trimmedName: NSString = self.nameTextField!.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
						if (Bool(trimmedName.length)) {
							self.addButton!.enabled = true;
						}
					}
				})
			}
			break;
		default:
			break;
		}
		return true
	}
	
}


