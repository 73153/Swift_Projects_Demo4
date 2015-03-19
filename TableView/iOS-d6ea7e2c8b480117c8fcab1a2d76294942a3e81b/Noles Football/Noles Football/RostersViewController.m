//
//  RostersViewController.m
//  NolesFootball
//
//  Created by Jonathan Steele on 1/22/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import "RostersViewController.h"

@implementation RostersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.staffList = [NSMutableArray array];
    self.playerList = [NSMutableArray array];
    
    static NSString *rostersURLString = @"http://grfx.cstv.com/schools/fsu/data/xml/roster/m-footbl-2013.xml";
    [self parsing:rostersURLString];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

@end
