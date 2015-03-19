//
//  Event.h
//  NolesFootball
//
//  Created by Jonathan Steele on 1/20/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic) NSString *homeTeam;
@property (nonatomic) NSString *awayTeam;
@property (nonatomic) NSString *homeScore;
@property (nonatomic) NSString *awayScore;
@property (nonatomic) NSDate *date;

@end
