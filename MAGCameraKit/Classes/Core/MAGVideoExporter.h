//
//  ITVideoExporter.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 09/09/16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SCRecorder.h"


@interface MAGVideoExporter : NSObject

- (void)exportVideoWithAsset:(AVAsset *)asset toURL:(NSURL *)distanseURL filter:(SCFilter *)filter completion:(void (^)(NSError *error))completion;

@end
