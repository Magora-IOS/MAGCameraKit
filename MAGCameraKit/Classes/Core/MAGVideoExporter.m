//
//  ITVideoExporter.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 09/09/16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "MAGVideoExporter.h"
#import <SVProgressHUD/SVProgressHUD.h>


@interface MAGVideoExporter () <SCAssetExportSessionDelegate>

@end


@implementation MAGVideoExporter


- (void)exportVideoWithAsset:(AVAsset*)asset toURL:(NSURL*)distanseURL filter:(SCFilter *)filter completion:(nonnull void (^)(NSError *error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:distanseURL.path]) {
            [[NSFileManager defaultManager] removeItemAtURL: distanseURL error: nil];
        }
        
        SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset: asset];
        exportSession.videoConfiguration.filter = filter;
        //exportSession.videoConfiguration.preset = SCPresetMediumQuality;
        //exportSession.audioConfiguration.preset = SCPresetHighestQuality;
        exportSession.videoConfiguration.keepInputAffineTransform = YES;
        exportSession.videoConfiguration.maxFrameRate = 30;
        exportSession.outputUrl = distanseURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.delegate = self;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (exportSession.error) {
                NSLog(@"exportSession error: %@", exportSession.error);
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:distanseURL.path] == NO) {
                NSLog(@"exportSession error: %@", @"File was not exported!");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                
                if (completion) {
                    completion(exportSession.error);
                }
            });
        }];
    });
}


- (void)assetExportSessionDidProgress:(SCAssetExportSession *__nonnull)assetExportSession {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showProgress:assetExportSession.progress status:@"Video Processing.." maskType:SVProgressHUDMaskTypeGradient];
    });
}




@end
