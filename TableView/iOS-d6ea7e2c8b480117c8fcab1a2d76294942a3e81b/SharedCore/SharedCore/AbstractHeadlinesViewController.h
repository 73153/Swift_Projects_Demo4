//
//  AbstractHeadlinesViewController.h
//  SharedCore
//
//  Created by Jonathan Steele on 2/9/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractHeadlinesViewController : UITableViewController

@property (nonatomic) NSMutableArray *list;

- (void) makeURLRequest:(NSString *)url;

@end
