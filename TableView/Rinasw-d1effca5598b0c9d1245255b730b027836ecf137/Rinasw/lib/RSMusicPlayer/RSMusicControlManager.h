//
//  RSMusicControlManager.h
//  Rinasw
//
//  Created by okenProg on 2014/06/07.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class RSMusicPlayer,RSMusicController;

@interface RSMusicControlManager : UIResponder

@property (strong, nonatomic) RSMusicController *musicController;

+ (instancetype)sharedManager;
- (void)remoteControlReceivedWithEvent:(UIEvent *)event;

- (void)updateControlCenterWithPlayer:(RSMusicPlayer *)player;

@end
