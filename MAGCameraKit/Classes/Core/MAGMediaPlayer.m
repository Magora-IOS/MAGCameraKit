//
//  ITMediaPlayer.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 05/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGMediaPlayer.h"
#import "MAGVideoExporter.h"
#import "UIImage+MAGCameraKit.h"
#import "MAGCameraKitCommon.h"


@interface MAGMediaPlayer ()

@property (strong, nonatomic) SCPlayer *player;
@property (weak, nonatomic) SCSwipeableFilterView *filterView;
@property (weak, nonatomic) MAGMediaPlayerView *playerView;
@property (strong, nonatomic) MAGVideoExporter *exporter;

@end


@implementation MAGMediaPlayer

- (instancetype)initWithFilterView:(MAGMediaFilterView *)filterView playerView:(MAGMediaPlayerView *)playerView {
    
    if (self = [super init]) {
        self.player = [SCPlayer player];
        self.filterView = filterView;
        self.playerView = playerView;
        playerView.hidden = YES;
        
        filterView.refreshAutomaticallyWhenScrolling = NO;
        filterView.contentMode = UIViewContentModeScaleAspectFill;
        filterView.selectFilterScrollView.scrollEnabled = NO;
        
        self.player.SCImageView = filterView;
        self.exporter = [MAGVideoExporter new];
        
        //AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        //playerLayer.frame = self.playerView.bounds;
        //[self.playerView.layer addSublayer:playerLayer];
        
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
        
        @weakify(self);
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            @strongify(self);
            [self pause];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            @strongify(self);
            [self play];
        }];
        
        //[self.filterView addObserver:self forKeyPath:@"selectedFilter" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    
    return self;
}


//- (SCPlayer *)player {
//    return self.playerView.player;
//}


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if (object == self.filterView) {
//        [self.filterView setNeedsDisplay];
//    }
//}


- (void)setRecordSession:(MAGRecordSession *)recordSession {
    _recordSession = recordSession;
    
    if (recordSession.videoAsset) {
        [self.player setItemByAsset:recordSession.videoAsset];
    }
}


- (void)play {
    
    // If filters will added then it need to be refactored
    SCFilter *emptyFilter = [SCFilter emptyFilter];
    emptyFilter.name = @"#nofilter";
    self.filterView.filters = @[emptyFilter];
    self.filterView.selectedFilter = emptyFilter;
    
    if (self.player.currentItem) {
        [self.player play];
        
    } else if (self.recordSession.photoImage) {
        [self.playerView showImage:self.recordSession.photoImage];
    }
}


- (void)pause {
    
    if (self.player.currentItem) {
        [self.player pause];
    }
}


- (void)exportMediaItem:(nonnull void(^)(MAGMediaPickerItem *item, NSError *error))completion {
    
    MAGMediaPickerItem *item = nil;
    
    if (self.recordSession.photoImage) {
        item = [MAGMediaPickerItem new];
        //item.image = [self filteredImage];
        item.image = [self scaledAndFilteredImage];
        item.type = MAGMediaTypeImage;
        completion(item, nil);
        
    } else if (self.recordSession.videoAsset) {
        item = [MAGMediaPickerItem new];
        item.type = MAGMediaTypeVideo;
        
        [self exportVideoItem:^(NSURL *url, NSError *error) {
            item.sourceURL = url;
            item.thumbnailImage = [self thumbnailImageFromURL:url];
            completion(item, error);
        }];
        
    } else {
        completion(nil, nil);
    }
}


- (void)exportVideoItem:(void(^)(NSURL *url, NSError *error))completion {
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = NSTemporaryDirectory(); //[paths objectAtIndex:0];
    directory = [directory stringByAppendingPathComponent:@"exported/"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    AVAsset *asset = self.recordSession.videoAsset;
    CGSize videoSize = [self.recordSession mediaSize]; //asset.tracks.firstObject.naturalSize;
    
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4", [self generateUUIDString]];
    NSURL *videoURL = [NSURL fileURLWithPath: [directory stringByAppendingPathComponent: fileName]];
    SCFilter *filter = [self overlayFilter:videoSize];
    
    [self.exporter exportVideoWithAsset:asset toURL:videoURL filter:filter completion:^(NSError *error) {
        if (completion) {
            completion(videoURL, error);
        }
    }];
}


- (UIImage *)thumbnailImageFromURL:(NSURL *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: videoURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    
    CMTime duration = asset.duration;
    CMTime requestedTime = CMTimeMake(0, duration.timescale);
    generator.appliesPreferredTrackTransform = YES;
    CGImageRef imgRef = [generator copyCGImageAtTime:requestedTime actualTime:NULL error:&err];
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return thumbnailImage;
}



// --- Overlay ---

- (UIImage *)scaledAndFilteredImage {
    UIImage *sourceImage = self.recordSession.photoImage;
    
    UIImage *scaledImage = [sourceImage scaledByFullHDAspectFit];
    scaledImage = [scaledImage fixOrientation];
    UIImage *resultImage = [self filteredImage:scaledImage];
    
    return resultImage;
}


- (UIImage *)filteredImage {
    UIImage *sourceImage = self.recordSession.photoImage;
    
    return [self filteredImage:sourceImage];
}


- (SCFilter *)overlayFilter:(CGSize)size {
    UIImage *overlayImage = self.recordSession.overlayImage;
    
    //if (CGSizeEqualToSize(size, overlayImage.size) == NO) {
        overlayImage = [self scaledImage:overlayImage toSize:size];
    //}
    
    return [self filterWithOverlay:overlayImage];
}


- (SCFilter *)filterWithOverlay:(UIImage *)image {
    if (image) {
        CIImage *ciImage = [[CIImage alloc] initWithImage:image];
        
        return [SCFilter filterWithCIImage:ciImage];
    }
    
    return nil;
}


- (UIImage *)filteredImage:(UIImage *)sourceImage {
    SCFilter *overlayFilter = [self overlayFilter:sourceImage.size];
    
    if (overlayFilter) {
        CIImage *ciSourceImage = [[CIImage alloc] initWithImage:sourceImage];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *result = [overlayFilter imageByProcessingImage:ciSourceImage];
        
        CGRect extent = [result extent];
        CGImageRef cgImage = [context createCGImage:result fromRect:extent];
        
        UIImage *filteredImage = [[UIImage alloc] initWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        return filteredImage;
    }
    
    return sourceImage;
}


- (UIImage *)scaledImage:(UIImage*)image toSize:(CGSize)newSize {
    UIImage* newImage = image;
    
    if (image) {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 1);
        
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}


- (NSString *)generateUUIDString {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}


@end
