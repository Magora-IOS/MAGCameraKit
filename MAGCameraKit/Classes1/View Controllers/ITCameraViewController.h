//
//  ITCameraViewController.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITCameraPresenter.h"
#import "ITRecordSession.h"
#import "MAGMediaPickerStringsProtocol.h"


typedef void(^ITCameraMediaRecorded)(ITRecordSession *session);
typedef void(^ITCameraCancelled)();


@interface ITCameraViewController : UIViewController

@property (strong, nonatomic) id<MAGMediaPickerStringsProtocol> strings;
@property (copy, nonatomic) ITCameraMediaRecorded mediaRecorded;
@property (copy, nonatomic) ITCameraCancelled cancelled;

- (void)startSession;
- (void)stopSession;

- (void)removeRecordedSession;

@end
