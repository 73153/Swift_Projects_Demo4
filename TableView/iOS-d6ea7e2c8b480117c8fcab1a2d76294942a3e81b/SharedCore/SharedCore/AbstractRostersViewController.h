//
//  AbstractRostersViewController.h
//  SharedCore
//
//  Created by Jonathan Steele on 2/9/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractRostersViewController : UITableViewController

@property (nonatomic) NSMutableArray *staffList;
@property (nonatomic) NSMutableArray *playerList;

- (void)parsing:(NSString *)url;

@end
