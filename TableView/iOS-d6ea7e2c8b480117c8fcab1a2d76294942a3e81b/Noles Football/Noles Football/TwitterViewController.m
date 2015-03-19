//
//  TwitterViewController.m
//  NolesFootball
//
//  Created by Jonathan Steele on 1/23/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import "TwitterViewController.h"

@implementation TwitterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self twitterTimeline:@"Seminoles_com"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

@end
