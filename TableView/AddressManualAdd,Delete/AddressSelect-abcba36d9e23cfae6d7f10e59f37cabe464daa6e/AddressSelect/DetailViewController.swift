//
//  DetailViewController.swift
//  AddressSelect
//
//  Created by Yoel R. GARCIA DIAZ on 10/06/2014.
//  Copyright (c) 2014 YRGD. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {
	
	@IBAction func shareAddressLocation(sender : AnyObject) {
		
		let addressLine = self.detailAddress!.lines(twoLines: false)
		let addressName = self.detailAddress!.name.capitalizedString
		let url = self.detailAddress!.placemark!.vcardUrlForAddressWithLine(addressLine, andName: addressName)
		
		var activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		
		activityController.excludedActivityTypes = [
			UIActivityTypePrint,
			UIActivityTypeCopyToPasteboard,
			UIActivityTypeAssignToContact,
			UIActivityTypeSaveToCameraRoll]
		
		self.presentViewController(activityController, animated:true, completion:nil)
	}
	
	@IBOutlet var mapView : MKMapView = nil
	
	var addressLocation: CLLocationCoordinate2D?
	var detailAddress: APAddress? {
	didSet {
		if let addr = detailAddress {
			if let loc = addr.placemark {
				self.addressLocation = loc.location.coordinate as? CLLocationCoordinate2D
			}
		}
	}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		//self.addressLocation = self.detailAddress.placemark!.location
	}
	
	override func viewDidAppear(animated: Bool) {
		var ann = APAddressAnnotation(coordinate: self.addressLocation!)
		ann.initWithTitle(self.detailAddress!.name, andSubtitle: self.detailAddress!.lines(twoLines: false))
		self.mapView.addAnnotation(ann)
		let region = MKCoordinateRegionMakeWithDistance(self.addressLocation!, 2000, 2000)
		self.mapView.setRegion(region, animated: true)
	}


}

