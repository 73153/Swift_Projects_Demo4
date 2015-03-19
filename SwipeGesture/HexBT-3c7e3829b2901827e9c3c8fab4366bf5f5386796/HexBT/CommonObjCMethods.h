//
//  CommonObjCMethods.h
//  HexBT
//
//  Created by Pan Ziyue on 11/6/14.
//  Copyright (c) 2014 Pan Ziyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonObjCMethods : NSObject

+(NSString *)textToBin:(NSString *)text;
+(NSString *)binToText:(NSString *)text;
+(NSString *)textToHex:(NSString *)text;
+(NSString *)hexToText:(NSString *)text;
+(NSString *)base64Encode:(NSString *)plainText;
+(NSString *)base64Decode:(NSString *)base64String;

@end
