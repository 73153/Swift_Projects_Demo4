//
//  SEJob.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-08.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import CoreData

class SEJob: NSManagedObject {
    
    /**
     * Property for saving _c5_source field returned from API for job object.
     */
    @NSManaged var c5Source: String
    
    /**
     * Property for saving client_account__c field returned from API for job object.
     */
    @NSManaged var clientAccountC: String
    
    /**
     * Property for saving client_contact__c field returned from API for job object.
     */
    @NSManaged var clientContactC: String
    
    /**
     * Property for saving client_name__c field returned from API for job object.
     */
    @NSManaged var clientNameC: String
    
    /**
     * Property for saving contact_name__c field returned from API for job object.
     */
    @NSManaged var contactNameC: String
    
    /**
     * Property for saving createddate field returned from API for job object.
     */
    @NSManaged var createdDate: NSDate
    
    /**
     * Property for saving id field returned from API for job object.
     */
    @NSManaged var identifier: Int
    
    /**
     * Property for saving info_text__c field returned from API for job object.
     */
    @NSManaged var infoTextC: String
    
    /**
     * Property for saving isdeleted field returned from API for job object.
     */
    @NSManaged var removed:String
    
    /**
     * Property for saving job_address__c field returned from API for job object.
     */
    @NSManaged var jobAddressC: String
    
    /**
     * Property for saving job_end_time__c field returned from API for job object.
     */
    @NSManaged var jobEndTimeC: NSDate
    
    /**
     * Property for saving job_name__c field returned from API for job object.
     */
    @NSManaged var jobNameC: String
    
    /**
     * Property for saving job_start_time__c field returned from API for job object.
     */
    @NSManaged var jobStartTimeC: NSDate
    
    /**
     * Property for saving lastmodifieddate field returned from API for job object.
     */
    @NSManaged var lastModifiedDate: NSDate
    
    /**
     * Property for saving latitude__c field returned from API for job object.
     */
    @NSManaged var latitudeC: Float
    
    /**
     * Property for saving longitude__c field returned from API for job object.
     */
    @NSManaged var longitudeC: Float
    
    /**
     * Property for saving name field returned from API for job object.
     */
    @NSManaged var name: String
    
    /**
     * Property for saving notes__c field returned from API for job object.
     */
    @NSManaged var notesC: String
    
    /**
     * Property for saving phone__c field returned from API for job object.
     */
    @NSManaged var phoneC: String
    
    /**
     * Property for saving sfid field returned from API for job object.
     */
    @NSManaged var sfid: String
    
    /**
     * Property for saving status__c field returned from API for job object.
     */
    @NSManaged var statusC: String
    
    /**
     * Property for saving job photos
     */
    @NSManaged var photos: Array<SEJobPhotoInfo>

    /**
     *  Dictionary of values needed for creating RKEntityMapping
     *
     *  @return NSDictionary of API key to property mappings
     */
    class var elementToPropertyMappings: Dictionary<String, String> {
        get {
            return [
                "id": "identifier",
                "name": "name",
                "job_name__c": "jobNameC",
                "job_address__c": "jobAddressC",
                "notes__c": "notesC",
                "info_text__c": "infoTextC",
                "contact_name__c": "contactNameC",
                "client_name__c": "clientNameC",
                "sfid": "sfid",
                "client_contact__c": "clientContactC",
                "client_account__c": "clientAccountC",
                "status__c": "statusC",
                "phone__c": "phoneC",
                "isdeleted": "removed",
                "_c5_source": "c5Source",
                "longitude__c": "longitudeC",
                "latitude__c": "latitudeC",
                "job_end_time__c": "jobEndTimeC",
                "job_start_time__c": "jobStartTimeC",
                "createddate": "createdDate",
                "lastmodifieddate": "lastModifiedDate"
            ]
        }
    }

    class func responseMappingForManagedObjectStore(managedObjectStore: RKManagedObjectStore) -> RKEntityMapping {
        var entityMapping = RKEntityMapping(forEntityForName:"SEJob", inManagedObjectStore: managedObjectStore)
        entityMapping.addAttributeMappingsFromDictionary(self.elementToPropertyMappings)
        entityMapping.identificationAttributes = ["identifier"]
        
        return entityMapping
    }
}
