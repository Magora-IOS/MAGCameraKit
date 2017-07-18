//
//  ITMediaPlayer.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 05/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <SCRecorder/SCRecorder.h>
#include "SCRecorder.h"
#import "MAGRecordSession.h"
#import "MAGMediaPickerItem.h"


@interface MAGMediaPlayer : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (strong, nonatomic) MAGRecordSession *recordSession;

- (instancetype)initWithFilterView:(SCSwipeableFilterView *)filterView playerView:(SCVideoPlayerView *)playerView;
- (void)play;
- (void)pause;

- (void)exportMediaItem:(nonnull void(^)(MAGMediaPickerItem *item, NSError *error))completion;
NS_ASSUME_NONNULL_END
@end
