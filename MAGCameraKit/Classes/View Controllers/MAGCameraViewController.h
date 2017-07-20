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


//typedef void(^MAGCameraCompleted)(MAGRecordSession *session);
//typedef void(^MAGCameraCancelled)();


@interface MAGCameraViewController : UIViewController <MAGCameraVCProtocol>

@property (strong, nonatomic) MAGCameraPresenter *presenter;
@property (strong, nonatomic) MAGCameraFlowCoordinator *coordinator;
@property (strong, nonatomic) id<MAGMediaPickerStringsProtocol> strings;
//@property (copy, nonatomic) MAGCameraCompleted completed;
//@property (copy, nonatomic) MAGCameraCancelled cancelled;

//- (void)startSession;
//- (void)stopSession;

//- (void)removeRecordedSession;

@end
