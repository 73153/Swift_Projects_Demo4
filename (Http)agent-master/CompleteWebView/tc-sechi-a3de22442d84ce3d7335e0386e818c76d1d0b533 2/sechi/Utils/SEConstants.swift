//
//  SEConstants.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-12.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import CoreLocation
import UIKit

let SEUserDefaultsUserStatusKey = "SEUserDefaultsUserStatusKey"
let SEPushMainMenuViewControllerSegue = "SEPushMainMenuViewControllerSegue"
let SEPushJobAddViewControllerSegue = "SEPushJobAddViewControllerSegue"
let SEPushJobsViewControllerSegue = "SEPushJobsViewControllerSegue"
let SEPushJobClientInfoEditViewControllerSegue = "SEPushJobClientInfoEditViewControllerSegue"
let SEPushPaymentAddViewControllerSegue = "SEPushPaymentAddViewControllerSegue"
let SEPushModalProductCodeReaderViewControllerSegue = "SEPushModalProductCodeReaderViewControllerSegue"

let SEJobTableViewCellIdentifier = "SEJobTableViewCellIdentifier"
let SEJobClientInfoTableViewCellIdentifier = "SEJobClientInfoTableViewCellIdentifier"
let SEJobAddressTableViewCellIdentifier = "SEJobAddressTableViewCellIdentifier"
let SEJobNotesTableViewCellIdentifier = "SEJobNotesTableViewCellIdentifier"
let SEJobPhotosTableViewCellIdentifier = "SEJobPhotosTableViewCellIdentifier"
let SEJobHoursTableViewCellIdentifier = "SEJobHoursTableViewCellIdentifier"

let SEClientTableViewCellIdentifier = "SEClientTableViewCellIdentifier"
let SEClientInfoTableViewCellIdentifier = "SEClientInfoTableViewCellIdentifier"
let SEClientAddressTableViewCellIdentifier = "SEClientAddressTableViewCellIdentifier"

let SEProductTableViewCellIdentifier = "SEProductTableViewCellIdentifier"

let SEPaymentTableViewCellIdentifier = "SEPaymentTableViewCellIdentifier"
let SEPaymentInfoTableViewCellIdentifier = "SEPaymentInfoTableViewCellIdentifier"

let SETextFieldTableViewCellIdentifier = "SETextFieldTableViewCellIdentifier"
let SEJobPhotoCollectionViewCellIdentifier = "SEJobPhotoCollectionViewCellIdentifier"

var HAS_4_INCH_SCREEN = UIScreen.mainScreen().bounds.size.height == 568

let TextFieldFont = UIFont(name: "Helvetica-Light", size: 16.0)
let NavigationBarFont = UIFont(name: "Helvetica-Light", size: 22.0)

/**
 *  User friendly message for CoreLocation errors
 *
 *  @param error error for which description is needed
 *
 *  @return error description or nil
 */
func messageForCLError(error: NSError?) -> String? {
    if let code = error?.code {
        switch code {
        case CLError.LocationUnknown.toRaw():
            return "Location is currently unknown, but application will keep trying to retreive it. Please check location access for this app in settings."
        case CLError.Denied.toRaw():
            return "Access to location or ranging has been denied by the user. Please check location access for this app in settings."
        case CLError.Network.toRaw():
            return "Network is not available. Please check network connection."
//      case CLError.HeadingFailure.toRaw():
//          return "Heading could not be determined"
        case CLError.RegionMonitoringDenied.toRaw():
            return "Location region monitoring has been denied by the user. Please check location access for this app in settings."
        case CLError.RegionMonitoringFailure.toRaw():
            return "Please validate provided address, and location access."
//          return "A registered region cannot be monitored."
//      case CLError.RegionMonitoringSetupDelayed.toRaw():
//          return "Application could not immediately initialize region monitoring"
//      case CLError.RegionMonitoringResponseDelayed.toRaw():
//          return "While events for this fence will be delivered, delivery will not occur immediately"
        case CLError.GeocodeFoundNoResult.toRaw():
            return "A geocode request yielded no result. Please check if address is valid."
        case CLError.GeocodeFoundPartialResult.toRaw():
            return "A geocode request yielded a partial result"
        case CLError.GeocodeCanceled.toRaw():
            return "A geocode request was cancelled"
        case CLError.DeferredFailed.toRaw():
            return "Deferred mode failed"
        case CLError.DeferredNotUpdatingLocation.toRaw():
            return "Deferred mode failed because location updates disabled or paused"
//      case CLError.DeferredAccuracyTooLow.toRaw():
//          return "Deferred mode not supported for the requested accuracy"
        case CLError.DeferredDistanceFiltered.toRaw():
            return "Deferred mode does not support distance filters"
        case CLError.DeferredCanceled.toRaw():
            return "Deferred mode request canceled a previous request"
        case CLError.RangingUnavailable.toRaw():
            return "Ranging cannot be performed"
        case CLError.RangingFailure.toRaw():
            return "General ranging failure"
        default:
            return nil
        }
    } else {
        return nil;
    }
}
