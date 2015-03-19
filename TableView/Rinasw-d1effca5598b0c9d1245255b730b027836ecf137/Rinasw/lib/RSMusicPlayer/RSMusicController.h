//
//  RSMusicController.h
//  Rinasw
//
//  Created by okenProg on 2014/06/07.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class RSMusicPlayer, RSMusicController;

@protocol RSMusicControllerDelegate <NSObject>
@optional
- (void)updatePlayerStautsOnMusicConroller:(RSMusicController *)controller;

@end

@interface RSMusicController : NSObject

@property (weak, nonatomic) id<RSMusicControllerDelegate> delegate;

- (RSMusicPlayer *)musicPlayer;
- (RSMusicPlayer *)switchToNextTrack;
- (RSMusicPlayer *)switchToPrevTrack;

- (void)receiveRemoteControEvent:(UIEvent *)event;
- (void)playerDidReachEnd:(NSNotification *)notification;

@end
