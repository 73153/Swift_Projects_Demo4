//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonOptionMatcher.h"
#import "TyphoonDefinition+Option.h"

@class TyphoonComponentFactory;
@protocol TyphoonInjection;

@interface TyphoonOptionMatcher (Internal)

- (instancetype)initWithBlock:(TyphoonMatcherBlock)block;

- (id<TyphoonInjection>)injectionMatchedValue:(id)value;

@end