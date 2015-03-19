//
//  CLPlacemark+Additions.h
//  AddressPicker
//
//  Created by Yoel R. GARCIA DIAZ on 07/06/2014.
//  Copyright (c) 2014 YRGD. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLPlacemark (Additions)

- (NSURL *)vcardUrlForAddressWithLine:(NSString *)addressLine andName:(NSString *)name;

@end
