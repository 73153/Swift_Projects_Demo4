//
//  APAddressAnnotation.swift
//  AddressSelect
//
//  Created by Yoel R. GARCIA DIAZ on 11/06/2014.
//  Copyright (c) 2014 YRGD. All rights reserved.
//

import UIKit
import MapKit

class APAddressAnnotation: NSObject, MKAnnotation {
	
	var innerCoordinate: CLLocationCoordinate2D? = nil
	var title: String = ""
	var subtitle: String = ""
	
	var coordinate: CLLocationCoordinate2D {
	get {
		return self.innerCoordinate!
	}
	set {
		self.innerCoordinate = newValue
	}
	}
	
	init(coordinate:CLLocationCoordinate2D) {
		super.init()
		self.innerCoordinate = coordinate
	}
	
	func initWithTitle(title: String, andSubtitle subtitle: String) {
		self.title = title
		self.subtitle = subtitle
	}
}
