//
//  SEProduct.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-08.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import CoreData

class SEProduct: NSManagedObject {
    
    /**
     * Property for saving id field returned by API for Product object.
     */
    @NSManaged var identifier: Int
    
    /**
     * Property for saving _c5_source field returned by API for Product object.
     */
    @NSManaged var c5Source: String
    
    /**
     * Property for saving isdeleted field returned by API for Product object.
     */
    @NSManaged var removed: String
    
    /**
     * Property for saving sfid field returned by API for Product object.
     */
    @NSManaged var sfid: String
    
    /**
     * Property for saving lastmodifieddate field returned by API for Product object.
     */
    @NSManaged var lastModifiedDate: NSDate
    
    /**
     * Property for saving createddate field returned by API for Product object.
     */
    @NSManaged var createdDate: NSDate
    
    /**
     * Property for saving name field returned by API for Product object.
     */
    @NSManaged var name: String
    
    /**
     * Property for saving isactive field returned by API for Product object.
     */
    @NSManaged var active: String
    
    /**
     * Property for saving desc field returned by API for Product object.
     */
    @NSManaged var desc: String
    
    /**
     * Property for saving family field returned by API for Product object.
     */
    @NSManaged var family: String
    
    /**
     * Property for saving productcode field returned by API for Product object.
     */
    @NSManaged var productcode: String

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
                "isactive": "active",
                "desc": "description",
                "family": "family",
                "productcode": "productcode"
            ]
        }
    }

    class func responseMappingForManagedObjectStore(managedObjectStore: RKManagedObjectStore) -> RKEntityMapping {
        var entityMapping = RKEntityMapping(forEntityForName: "SEProduct", inManagedObjectStore: managedObjectStore)
        entityMapping.addAttributeMappingsFromDictionary(self.elementToPropertyMappings)
        entityMapping.identificationAttributes = ["identifier"]
        
        return entityMapping
    }
}
