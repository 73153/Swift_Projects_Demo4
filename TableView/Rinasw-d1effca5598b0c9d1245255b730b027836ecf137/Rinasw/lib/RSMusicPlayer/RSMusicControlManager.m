//
//  RSMusicControlManager.m
//  Rinasw
//
//  Created by okenProg on 2014/06/07.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

#import "RSMusicControlManager.h"
#import "RSMusic.h"
@import AVFoundation;

@interface RSMusicControlManager ()

@end

@implementation RSMusicControlManager

+ (instancetype)sharedManager
{
    static RSMusicControlManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[RSMusicControlManager alloc] init];
    });
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupAudioSession];
        [self setupNotification];
    }
    return self;
}

- (void)setupAudioSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"AVSession setCategoryError %@", error);
        exit(1);
    }

    [session setActive:true error:&error];
    if (error) {
        NSLog(@"AVSession setActivError %@", error);
        exit(1);
    }
}

#pragma mark - Notification 

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self.musicController playerDidReachEnd:notification];
}


- (void)updateControlCenterWithPlayer:(RSMusicPlayer *)player
{
    if (!player.musicInfo) {
        return;
    }
    
    RSMusicInfo *musicInfo = player.musicInfo;
    NSMutableDictionary *nowPlaingInfo = [NSMutableDictionary dictionary];
    [self appendObject:musicInfo.title forKey:MPMediaItemPropertyTitle inDictionary:nowPlaingInfo];
    [self appendObject:musicInfo.artist forKey:MPMediaItemPropertyArtist inDictionary:nowPlaingInfo];
    [self appendObject:musicInfo.albumTitle forKey:MPMediaItemPropertyAlbumTitle inDictionary:nowPlaingInfo];
    [self appendObject:musicInfo.albumArtist forKey:MPMediaItemPropertyAlbumArtist inDictionary:nowPlaingInfo];
    [self appendObject:@(musicInfo.duration) forKey:MPMediaItemPropertyPlaybackDuration inDictionary:nowPlaingInfo];
    [self appendObject:@(player.elapsedTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime inDictionary:nowPlaingInfo];
    [self appendObject:@(player.rate) forKey:MPNowPlayingInfoPropertyPlaybackRate inDictionary:nowPlaingInfo];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nowPlaingInfo;
}

- (void)appendObject:(id)object forKey:(id)key inDictionary:(NSMutableDictionary *)dict
{
    if (object && key) {
        dict[key] = object;
    }
}

#pragma mark - Remote Control Event

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        [self.musicController receiveRemoteControEvent:event];
    }
}

#pragma mark - Setter

- (void)setMusicController:(RSMusicController *)musicController
{
    if (musicController != _musicController) {
        RSMusicPlayer *player = [_musicController musicPlayer];
        [player pause];
    }
    _musicController = musicController;
}


@end
