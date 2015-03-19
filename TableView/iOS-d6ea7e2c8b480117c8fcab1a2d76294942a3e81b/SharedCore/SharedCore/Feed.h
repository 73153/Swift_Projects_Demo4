//
//  Feed.h
//  NolesFootball
//
//  Created by Jonathan Steele on 1/19/14.
//  Copyright (c) 2014 Jonathan Steele. All rights reserved.
//

@interface Feed : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *link;
@property (nonatomic) NSString *pubDate;
@property (nonatomic) NSString *imageURLString;
@property (nonatomic) UIImage *icon;

@end
