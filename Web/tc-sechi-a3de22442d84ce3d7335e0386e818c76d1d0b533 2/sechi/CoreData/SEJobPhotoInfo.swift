//
//  SEJobPhotoInfo.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-08.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import CoreData

class SEJobPhotoInfo: NSManagedObject {
    
    /**
     *  Path of the file where it was saved on the device.
     */
    @NSManaged var filePath: String
    
    /**
     *  SEJob object which is an owner of this photo.
     */
    @NSManaged var job: SEJob
}
