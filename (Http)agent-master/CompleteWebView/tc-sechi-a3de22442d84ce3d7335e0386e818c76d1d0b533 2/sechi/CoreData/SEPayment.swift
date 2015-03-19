//
//  SEPayment.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-08.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import CoreData

class SEPayment: NSManagedObject {
    
    /**
     * Property for saving id field returned from API for Payment object.
     */
    @NSManaged var identifier: Int
    
    /**
     * Property for saving _c5_source field returned from API for Payment object.
     */
    @NSManaged var c5Source: String
    
    /**
     * Property for saving isdeleted field returned from API for Payment object.
     */
    @NSManaged var removed: String
    
    /**
     * Property for saving sfid field returned from API for Payment object.
     */
    @NSManaged var sfid: String
    
    /**
     * Property for saving lastmodifieddate field returned from API for Payment object.
     */
    @NSManaged var lastModifiedDate: NSDate
    
    /**
     * Property for saving createddate field returned from API for Payment object.
     */
    @NSManaged var createdDate: NSDate
    
    /**
     * Property for saving name field returned from API for Payment object.
     */
    @NSManaged var name: String
    
    /**
     * Property for saving svc_job__c field returned from API for Payment object.
     */
    @NSManaged var svcJobC: String
    
    /**
     * Property for saving payment_notes__c field returned from API for Payment object.
     */
    @NSManaged var paymentNotesC: String
    
    /**
     * Property for saving status__c field returned from API for Payment object.
     */
    @NSManaged var statusC: String
    
    /**
     * Property for saving client_name__c field returned from API for Payment object.
     */
    @NSManaged var clientNameC: String
    
    /**
     * Property for saving client_account__c field returned from API for Payment object.
     */
    @NSManaged var clientAccountC: String
    
    /**
     * Property for saving job_name__c field returned from API for Payment object.
     */
    @NSManaged var jobNameC: String
    
    /**
     * Property for saving payment_date__c field returned from API for Payment object.
     */
    @NSManaged var paymentDateC: NSDate
    
    /**
     * Property for saving payment_amount__c field returned from API for Payment object.
     */
    @NSManaged var paymentAmountC: Int

    /**
     *  Dictionary of values needed for creating RKEntityMapping
     *
     *  @return NSDictionary of API key to property mappings
     */
    class var elementToPropertyMappings: Dictionary<String, String> {
        get {
            return [
                "id": "identifier",
                "_c5_source": "c5Source",
                "isdeleted": "removed",
                "sfid": "sfid",
                "lastmodifieddate": "lastModifiedDate",
                "createddate": "createdDate",
                "name": "name",
                "svc_job__c": "svcJobC",
                "payment_notes__c": "paymentNotesC",
                "status__c": "statusC",
                "client_name__c": "clientNameC",
                "client_account__c": "clientAccountC",
                "job_name__c": "jobNameC",
                "payment_date__c": "paymentDateC",
                "payment_amount__c": "paymentAmountC"
            ]
        }
    }

    class func responseMappingForManagedObjectStore(managedObjectStore: RKManagedObjectStore) -> RKEntityMapping {
        var entityMapping = RKEntityMapping(forEntityForName: "SEPayment", inManagedObjectStore: managedObjectStore)
        entityMapping.addAttributeMappingsFromDictionary(self.elementToPropertyMappings)
        entityMapping.identificationAttributes = ["identifier"]
        
        return entityMapping
    }
}
