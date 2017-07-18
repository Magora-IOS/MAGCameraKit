//
//  ITRecordSession.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class SCRecordSession;
@import AVFoundation;

@interface ITRecordSession : NSObject

@property (strong, nonatomic) UIImage *photoImage;
@property (strong, nonatomic) AVAsset *videoAsset;
//@property (strong, nonatomic) CIFilter *mediaFilter;
@property (strong, nonatomic) UIImage *overlayImage;

- (CGSize)mediaSize;


//- (UIImage *)filteredImage;

@end
