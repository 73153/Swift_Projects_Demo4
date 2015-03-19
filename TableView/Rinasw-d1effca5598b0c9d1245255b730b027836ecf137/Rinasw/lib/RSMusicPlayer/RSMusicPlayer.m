//
//  RSMusicPlayer.m
//  Rinasw
//
//  Created by okenProg on 2014/06/07.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

#import "RSMusicPlayer.h"
@import CoreMedia;
@import MediaPlayer;
@import AVFoundation;

@interface RSMusicPlayer ()
@property (strong, nonatomic) AVPlayer *player;
@end

@implementation RSMusicPlayer

+ (instancetype)playerWithInfo:(RSMusicInfo *)info
{
    return [[self alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(RSMusicInfo *)info
{
    self = [super init];
    if (self) {
        self.musicInfo = info;
    }
    return self;
}


#pragma mark - Play Music

- (void)play
{
    [self.player play];
    [[RSMusicControlManager sharedManager] updateControlCenterWithPlayer:self];
}

- (void)pause
{
    [self.player pause];
    [[RSMusicControlManager sharedManager] updateControlCenterWithPlayer:self];
}

- (void)togglePlayPause
{
    if (self.playerStatus == RSMusicPlayerStatusPlay) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)seekToTime:(double)time
{
    [self.player seekToTime:CMTimeMake(time, 1)];
    [[RSMusicControlManager sharedManager] updateControlCenterWithPlayer:self];
}

#pragma mark - Accessor

- (double)elapsedTime
{
    return CMTimeGetSeconds([self.player currentTime]);
}

- (double)duration
{
    return self.musicInfo.duration;
}

- (float)rate
{
    return self.player.rate;
}

- (void)setMusicInfo:(RSMusicInfo *)musicInfo
{
    _musicInfo = musicInfo;
    [self setupPlayerWithPlayerItem:self.musicInfo.playerItem];
}

- (RSMusicPlayerStatus)playerStatus
{
    if (self.player.rate == 0.0) {
        return RSMusicPlayerStatusPause;
    } else {
        return RSMusicPlayerStatusPlay;
    }
}

#pragma mark - setup

- (void)setupPlayerWithPlayerItem:(AVPlayerItem *)item
{
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
}


@end
