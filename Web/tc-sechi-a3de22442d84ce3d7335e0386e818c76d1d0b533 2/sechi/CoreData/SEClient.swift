//
//  SEClient.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-08.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import CoreData

class SEClient: NSManagedObject {
    
    /*
     * Property for saving id field returned by API for Client object.
     */
    @NSManaged var identifier: Int
    
    /*
     * Property for saving _c5_source field returned by API for Client object.
     */
    @NSManaged var c5Source: String
    
    /*
     * Property for saving name field returned by API for Client object.
     */
    @NSManaged var name: String
    
    /*
     * Property for saving lastmodifieddate field returned by API for Client object.
     */
    @NSManaged var lastModifiedDate: NSDate
    
    /*
     * Property for saving isdeleted field returned by API for Client object.
     */
    @NSManaged var removed: String
    
    /*
     * Property for saving sfid field returned by API for Client object.
     */
    @NSManaged var sfid: String

    /*
     * Property for saving createddate field returned by API for Client object.
     */
    @NSManaged var createdDate: NSDate
    
    /*
     * Property for saving firstname field returned by API for Client object.
     */
    @NSManaged var firstname: NSDate
    
    /*
     * Property for saving lastname field returned by API for Client object.
     */
    @NSManaged var lastname: String
    
    /*
     * Property for saving email field returned by API for Client object.
     */
    @NSManaged var email: String
    
    /*
     * Property for saving business_phone__c field returned by API for Client object.
     */
    @NSManaged var businessPhoneC: String
    
    /*
     * Property for saving company_address__c field returned by API for Client object.
     */
    @NSManaged var companyAddressC: String
    
    /*
     * Property for saving phone field returned by API for Client object.
     */
    @NSManaged var phone: String
    
    /*
     * Property for saving company_name__c field returned by API for Client object.
     */
    @NSManaged var companyNameC: String

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
                "name": "name",
                "lastmodifieddate": "lastModifiedDate",
                "isdeleted": "removed",
                "sfid": "sfid",
                "createddate": "createdDate",
                "firstname": "firstname",
                "lastname": "lastname",
                "email": "email",
                "business_phone__c": "businessPhoneC",
                "company_address__c": "companyAddressC",
                "phone": "phone",
                "company_name__c": "companyNameC"
            ]
        }
    }

    class func responseMappingForManagedObjectStore(managedObjectStore: RKManagedObjectStore) -> RKEntityMapping {
        var entityMapping = RKEntityMapping(forEntityForName: "SEClient", inManagedObjectStore: managedObjectStore)
        entityMapping.addAttributeMappingsFromDictionary(self.elementToPropertyMappings)
        entityMapping.identificationAttributes = ["identifier"]
        
        return entityMapping
    }
}
