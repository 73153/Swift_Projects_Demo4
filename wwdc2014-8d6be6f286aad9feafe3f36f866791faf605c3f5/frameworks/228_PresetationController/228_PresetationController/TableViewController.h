//
//  TableViewController.h
//  228_PresetationController
//
//  Created by llv23 on 8/26/14.
//  Copyright (c) 2014 llv22. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface TableViewController : UITableViewController

@property(nonatomic, weak) ViewController* parentVC;
@property(nonatomic, weak) NSArray* people;

@end
