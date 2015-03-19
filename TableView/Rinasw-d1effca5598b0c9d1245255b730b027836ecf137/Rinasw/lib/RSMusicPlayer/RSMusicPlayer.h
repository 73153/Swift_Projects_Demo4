//
//  RSMusicPlayer.h
//  Rinasw
//
//  Created by okenProg on 2014/06/07.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSMusic.h"

typedef NS_ENUM(NSUInteger, RSMusicPlayerStatus) {
    RSMusicPlayerStatusNone,
    RSMusicPlayerStatusPlay,
    RSMusicPlayerStatusPause,
};

@interface RSMusicPlayer : NSObject

@property (readonly) double elapsedTime;
@property (readonly) double duration;
@property (readonly) float rate;
@property (strong, nonatomic) RSMusicInfo *musicInfo;

+ (instancetype)playerWithInfo:(RSMusicInfo *)info;
- (void)play;
- (void)pause;
- (void)togglePlayPause;
- (void)seekToTime:(double)time;
- (RSMusicPlayerStatus)playerStatus;

@end
