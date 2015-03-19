//
//  RSMusicInfo.m
//  Rinasw
//
//  Created by okenProg on 2014/06/07.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

#import "RSMusicInfo.h"

@interface RSMusicInfo ()

@property (readwrite, strong, nonatomic) NSString *title;
@property (readwrite, strong, nonatomic) NSString *artist;
@property (readwrite, strong, nonatomic) NSString *albumTitle;
@property (readwrite, strong, nonatomic) NSString *albumArtist;
@property (readwrite, assign, nonatomic) double duration;
@property (readwrite, strong, nonatomic) MPMediaItemArtwork *artwork;

@property (readwrite, strong, nonatomic) MPMediaItem *mediaItem;
@property (readwrite, strong, nonatomic) AVPlayerItem *playerItem;

@end

@implementation RSMusicInfo

+ (instancetype)infoWithMediaItem:(MPMediaItem *)item
{
    RSMusicInfo *info = [[RSMusicInfo alloc] init];
    [info assembleInfoWithMediaItem:item];
    return info;
}

- (void)assembleInfoWithMediaItem:(MPMediaItem *)item
{
    self.mediaItem = item;
    
    // media info
    self.title = [self.mediaItem valueForProperty:MPMediaItemPropertyTitle];
    self.artist = [self.mediaItem valueForProperty:MPMediaItemPropertyArtist];
    self.albumTitle = [self.mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    self.albumArtist = [self.mediaItem valueForProperty:MPMediaItemPropertyAlbumArtist];
    self.duration = [[self.mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    self.artwork = [self.mediaItem valueForProperty:MPMediaItemPropertyArtwork];
    
    // player info
    self.playerItem = [self playerItemWithMediaItem:self.mediaItem];
}

- (AVPlayerItem *)playerItemWithMediaItem:(MPMediaItem *)item
{
    NSURL *assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *asset = [AVURLAsset assetWithURL:assetURL];
    return [AVPlayerItem playerItemWithAsset:asset];
}

- (UIImage *)artworkImage
{
    UIImage *image = [self.artwork imageWithSize:self.artwork.bounds.size];
    return image;
}

@end
