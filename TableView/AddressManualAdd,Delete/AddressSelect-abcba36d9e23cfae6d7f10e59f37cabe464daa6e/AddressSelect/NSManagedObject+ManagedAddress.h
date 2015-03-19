//
//  NSManagedObject+ManagedAddress.h
//  AddressPicker
//
//  Created by Yoel R. GARCIA DIAZ on 07/06/2014.
//  Copyright (c) 2014 YRGD. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface NSManagedObject (ManagedAddress)

@property (nonatomic) NSString *name, *searchString;
@property (nonatomic) CLPlacemark *placemark;
@property (nonatomic) NSDate *timeStamp;

@end
