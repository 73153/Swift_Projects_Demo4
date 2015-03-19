//
//  APAddress.swift
//  AddressSelect
//
//  Created by Yoel R. GARCIA DIAZ on 10/06/2014.
//  Copyright (c) 2014 YRGD. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import AddressBook

class APAddress: NSObject {
	
	var name: NSString = ""
	var searchString: NSString = ""
	var placemark: CLPlacemark?
	
	let addressProperties: String[] = [
		"subThoroughfare",
		"thoroughfare",
		"locality",
		"administrativeArea",
		"postalCode"
	]
	
	init() {
		super.init()
	}
	
	func description() -> String {
		return "name: \(self.name), searchString: \(self.searchString), placemark: \(self.placemark.description)"
	}
	
	func lines(#twoLines: Bool) -> String {
		var lines = ""
		for (i: Int, prop: String) in enumerate(self.addressProperties) {
			var propVal = placemark!.valueForKey(prop) as? String
			if let s = propVal {
				twoLines && i == 1 ? (lines += s + "\n") : (lines += s + " ")
			}
		}
		return lines
	}
	
	class func addressFromManagedObject(#object: NSManagedObject) -> APAddress {
		var anAddress = APAddress()
		anAddress.name = object.name;
		anAddress.searchString = object.searchString;
		anAddress.placemark = object.placemark as? CLPlacemark;
		return anAddress;
	}

}
