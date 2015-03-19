////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////




#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(NSObject_TyphoonIntrospectionUtils)

#import <objc/runtime.h>
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonStringUtils.h"


@implementation NSObject (TyphoonIntrospectionUtils)

- (TyphoonTypeDescriptor *)typhoon_typeForPropertyWithName:(NSString *)propertyName
{
    return [TyphoonIntrospectionUtils typeForPropertyWithName:propertyName inClass:[self class]];
}

@end
