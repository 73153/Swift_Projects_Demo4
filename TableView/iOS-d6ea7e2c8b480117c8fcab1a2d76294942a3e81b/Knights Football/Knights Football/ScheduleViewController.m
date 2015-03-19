//
//  ScheduleViewController.m
//  NolesFootball
//
//  Created by Jonathan Steele on 1/19/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import "ScheduleViewController.h"

@implementation ScheduleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.list = [NSMutableArray array];
    
    static NSString *scheduleURLString = @"http://cbs-amp2.silverchalice.co/cbs/api/events?schoolCode=ucf&sportCode=m-footbl";
    [self makeURLRequest:scheduleURLString];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

@end
