//
//  HeadlinesViewController.m
//  NolesFootball
//
//  Created by Jonathan Steele on 1/19/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import "HeadlinesViewController.h"

@implementation HeadlinesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.list = [NSMutableArray array];

    static NSString *feedURLString = @"http://www.ucfknights.com/headline-rss.xml";
    [self makeURLRequest:feedURLString];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

@end
