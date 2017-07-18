//
//  ITRecordSession.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "ITRecordSession.h"

@implementation ITRecordSession


- (CGSize)mediaSize; {
    
    if (self.photoImage) {
        return self.photoImage.size;
        
    } else if (self.videoAsset) {
        CGSize videoSize = self.videoAsset.tracks.firstObject.naturalSize;
        
        return videoSize;
    }
    
    return CGSizeZero;
}


@end
