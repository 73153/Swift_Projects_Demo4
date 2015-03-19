//
//  RSMusicController.m
//  Rinasw
//
//  Created by okenProg on 2014/06/07.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

#import "RSMusicController.h"

@implementation RSMusicController

- (RSMusicPlayer *)musicPlayer
{
    return nil;
}

- (RSMusicPlayer *)switchToNextTrack
{
    return nil;
}

- (RSMusicPlayer *)switchToPrevTrack
{
    return nil;
}

- (void)receiveRemoteControEvent:(UIEvent *)event
{
    // abstract
}

- (void)playerDidReachEnd:(NSNotification *)notification
{
    // abstract
}

@end
