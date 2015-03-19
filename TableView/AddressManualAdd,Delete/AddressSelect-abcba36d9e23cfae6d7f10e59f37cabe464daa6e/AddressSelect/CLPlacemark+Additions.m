//
//  CLPlacemark+Additions.m
//  AddressPicker
//
//  Created by Yoel R. GARCIA DIAZ on 07/06/2014.
//  Copyright (c) 2014 YRGD. All rights reserved.
//

#import "CLPlacemark+Additions.h"
#import <AddressBook/AddressBook.h>

@implementation CLPlacemark (Additions)

- (NSURL *)vcardUrlForAddressWithLine:(NSString *)addressLine andName:(NSString *)name {
	
	CLLocationCoordinate2D location = self.location.coordinate;
	
	ABRecordRef person = ABPersonCreate();
	ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(name), nil);
	
	ABMutableMultiValueRef multiValAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
	bool addHomeAddress = ABMultiValueAddValueAndLabel(multiValAddress, (__bridge CFTypeRef)(self.addressDictionary), kABHomeLabel, NULL);
	if (addHomeAddress) ABRecordSetValue(person, kABPersonAddressProperty, multiValAddress, NULL);
	
	NSString *mapUrl = [NSString stringWithFormat:@"http://maps.apple.com/?lsp=6489&sll=%f,%f&q=%@", location.latitude, location.longitude, addressLine];
	NSString *encodedUrl = [mapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	ABMutableMultiValueRef multiValURL = ABMultiValueCreateMutable(kABMultiStringPropertyType );
	bool addURL = ABMultiValueAddValueAndLabel(multiValURL, (__bridge CFTypeRef)(encodedUrl), (__bridge CFTypeRef)@"map url", NULL);
	if (addURL) ABRecordSetValue(person, kABPersonURLProperty, multiValURL, NULL);
	
	NSArray *individual = @[(__bridge id)(person)];
	CFArrayRef arrayRef = (__bridge CFArrayRef)individual;
	NSData *vcard = (__bridge_transfer NSData *)ABPersonCreateVCardRepresentationWithPeople(arrayRef);
	NSString *vcardString = [[NSString alloc] initWithData:vcard encoding:NSASCIIStringEncoding];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.loc.vcf", name]];
	
	CFRelease(person);
	CFRelease(multiValAddress);
	CFRelease(multiValURL);
	
	NSError *error = nil;
	[vcardString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
	return [NSURL fileURLWithPath:filePath];
}

@end
