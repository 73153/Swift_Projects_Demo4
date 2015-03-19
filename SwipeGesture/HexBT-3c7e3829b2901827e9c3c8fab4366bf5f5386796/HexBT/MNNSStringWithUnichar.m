//
//  MNNSStringWithUnichar.m
//  HexBT
//
//  Created by Pan Ziyue on 7/8/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import "MNNSStringWithUnichar.h"

@implementation MNNSStringWithUnichar

+ (NSString *) stringWithUnichar:(unichar) value {
    NSString *str = [NSString stringWithFormat: @"%C", value];
    return str;
}

@end
