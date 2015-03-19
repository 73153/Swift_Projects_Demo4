//
//  RSMusicInfo.h
//  Rinasw
//
//  Created by okenProg on 2014/06/07.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MediaPlayer;
@import AVFoundation;

@interface RSMusicInfo : NSObject

@property (readonly) NSString *title;
@property (readonly) NSString *artist;
@property (readonly) NSString *albumTitle;
@property (readonly) NSString *albumArtist;
@property (readonly) double duration;
@property (readonly) MPMediaItemArtwork *artwork;
@property (readonly) UIImage *artworkImage;

@property (readonly) MPMediaItem *mediaItem;
@property (readonly) AVPlayerItem *playerItem;

+ (instancetype)infoWithMediaItem:(MPMediaItem *)item;

@end
