//
//  ScheduleTableCell.h
//  SharedCore
//
//  Created by Jonathan Steele on 5/19/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;

@interface ScheduleTableCell : UITableViewCell

- (void)configureWithEvents:(Event *)event;

@end
