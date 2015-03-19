//
//  RSMusicRandomController.h
//  Rinasw
//
//  Created by okenProg on 2014/06/07.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSMusicController.h"

@class RSMusicInfo;

@interface RSMusicRandomController : RSMusicController

- (NSArray *)randomMusicInfoListWithLimt:(NSInteger)limit;
- (void)changeTrackWithMusicInfo:(RSMusicInfo *)musicInfo;

@end
