//
//  ITCameraViewController.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGCameraPresenter.h"
#import "MAGRecordSession.h"
#import "MAGMediaPickerStringsProtocol.h"


typedef void(^MAGCameraMediaRecorded)(MAGRecordSession *session);
typedef void(^MAGCameraCancelled)();


@interface MAGCameraViewController : UIViewController

@property (strong, nonatomic) id<MAGMediaPickerStringsProtocol> strings;
@property (copy, nonatomic) MAGCameraMediaRecorded mediaRecorded;
@property (copy, nonatomic) MAGCameraCancelled cancelled;

- (void)startSession;
- (void)stopSession;

- (void)removeRecordedSession;

@end
