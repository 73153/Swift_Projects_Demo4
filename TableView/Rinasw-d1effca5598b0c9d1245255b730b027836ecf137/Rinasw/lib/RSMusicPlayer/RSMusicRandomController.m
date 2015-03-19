//
//  RSMusicRandomController.m
//  Rinasw
//
//  Created by okenProg on 2014/06/07.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

#import "RSMusicRandomController.h"
#import "RSMusic.h"
@import MediaPlayer;
@import CoreMedia;

@interface RSMusicRandomController ()

@property (strong, nonatomic) RSMusicPlayer *player;
@property (strong, nonatomic) NSArray *mediaItems;
@property (strong, nonatomic) NSMutableArray *musicStack;
@property (strong, nonatomic) NSMutableArray *musicPool; // remain music

@end

@implementation RSMusicRandomController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    self.mediaItems = query.items;
    self.musicStack = [NSMutableArray array];
    self.musicPool = [self.mediaItems mutableCopy];
    
    [self switchToNextTrack];
}


#pragma mark - Concrete

- (RSMusicPlayer *)musicPlayer
{
    return self.player;
}

- (RSMusicPlayer *)switchToNextTrack
{
    MPMediaItem *item = [self pickupNextItem];
    RSMusicPlayer *player = [self switchPlayerWithItem:item];
    return player;
}

- (RSMusicPlayer *)switchToPrevTrack
{
    MPMediaItem *item = [self pickupPrevItem];
    RSMusicPlayer *player = [self switchPlayerWithItem:item];
    return player;
}

- (MPMediaItem *)pickupNextItem
{
    if (self.musicPool.count == 0) {
        return nil;
    }
    
    MPMediaItem *currentItem = self.player.musicInfo.mediaItem;
    if (currentItem) {
        NSUInteger currentIndex = [self.musicStack indexOfObject:currentItem];
        if (currentIndex < self.musicStack.count-1) {
            return self.musicStack[currentIndex+1];
        }
    }
    
    int index = arc4random() % self.musicPool.count;
    MPMediaItem *item = self.musicPool[index];
    [self.musicStack addObject:item];
    [self.musicPool removeObject:item];
    
    return item;
}

- (MPMediaItem *)pickupPrevItem
{
    if (self.musicStack.count == 0) {
        return nil;
    }
    
    MPMediaItem *currentItem = self.player.musicInfo.mediaItem;
    NSUInteger currentIndex = [self.musicStack indexOfObject:currentItem];
    if (currentIndex ==  NSNotFound || currentIndex == 0) {
        return nil;
    }
    
    MPMediaItem *prevItem = self.musicStack[currentIndex-1];
    return prevItem;
}

- (RSMusicPlayer *)switchPlayerWithItem:(MPMediaItem *)item
{
    RSMusicPlayer *player;
    if (item) {
        RSMusicPlayerStatus status = [self.player playerStatus];
        RSMusicInfo *info = [RSMusicInfo infoWithMediaItem:item];
        self.player = player = [self playerWithInfo:info];
        if (status == RSMusicPlayerStatusPlay) {
            [self.player play];
        }
    }
    
    return player;
}


- (RSMusicPlayer *)playerWithInfo:(RSMusicInfo *)info
{
    RSMusicPlayer *player;
    if (self.player) {
        player = self.player;
        player.musicInfo = info;
    } else {
        player = [RSMusicPlayer playerWithInfo:info];
    }
    
    return player;
}

- (void)receiveRemoteControEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self.player play];
            [self notifyPlayerStateChange];
            break;
            
        case UIEventSubtypeRemoteControlPause:
            [self.player pause];
            [self notifyPlayerStateChange];
            break;
            
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self.player togglePlayPause];
            [self notifyPlayerStateChange];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self switchToPrevTrack];
            [self notifyPlayerStateChange];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self switchToNextTrack];
            [self notifyPlayerStateChange];
            break;
            
        default:
            break;
    }
}

- (void)playerDidReachEnd:(NSNotification *)notification
{
    [self switchToNextTrack];
    [self notifyPlayerStateChange];
}

#pragma mark - Public

- (NSArray *)randomMusicInfoListWithLimt:(NSInteger)limit
{
    NSMutableArray *pool = [self.mediaItems mutableCopy];
    // removae currentItem
    MPMediaItem *currentItem = self.player.musicInfo.mediaItem;
    [pool removeObject:currentItem];
    
    NSMutableArray *randomMusicList = [NSMutableArray array];
    for (int i=0; i<limit; i++) {
        if ([pool count] == 0)
            break;
        NSInteger index = arc4random()%[pool count];
        MPMediaItem *item = pool[index];
        [pool removeObjectAtIndex:index];
        RSMusicInfo *info = [RSMusicInfo infoWithMediaItem:item];
        [randomMusicList addObject:info];
    }
    
    return randomMusicList;
}

- (void)changeTrackWithMusicInfo:(RSMusicInfo *)musicInfo
{
    MPMediaItem *item =  musicInfo.mediaItem;
    MPMediaItem *currentItem = self.player.musicInfo.mediaItem;
    if (item == currentItem) {
        return;
    }
    
    NSUInteger itemIndex = [self.musicStack indexOfObject:item];
    if (itemIndex != NSNotFound) {
        [self.musicStack removeObjectAtIndex:itemIndex];
        [self.musicPool addObject:item];
    }
    
    [self.musicStack addObject:item];
    [self.musicPool removeObject:item];
    RSMusicPlayer *player = [self switchPlayerWithItem:item];
    if (player) {
        self.player = player;
        [self notifyPlayerStateChange];
    }
}

#pragma mark - Setter

- (void)setPlayer:(RSMusicPlayer *)player
{
    _player = player;
    [[RSMusicControlManager sharedManager] updateControlCenterWithPlayer:self.player];
}

#pragma mark - Subcontract

- (void)notifyPlayerStateChange
{
    if ([self.delegate respondsToSelector:@selector(updatePlayerStautsOnMusicConroller:)]) {
        [self.delegate updatePlayerStautsOnMusicConroller:self];
    }
}


@end
