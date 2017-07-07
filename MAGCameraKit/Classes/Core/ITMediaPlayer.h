//
//  ITMediaPlayer.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 05/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SCRecorder/SCRecorder.h>
#import "ITRecordSession.h"
#import "ITMediaPickerItem.h"


@interface ITMediaPlayer : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (strong, nonatomic) ITRecordSession *recordSession;

- (instancetype)initWithFilterView:(SCSwipeableFilterView *)filterView playerView:(SCVideoPlayerView *)playerView;
- (void)play;
- (void)pause;

- (void)exportMediaItem:(nonnull void(^)(ITMediaPickerItem *item, NSError *error))completion;
NS_ASSUME_NONNULL_END
@end
