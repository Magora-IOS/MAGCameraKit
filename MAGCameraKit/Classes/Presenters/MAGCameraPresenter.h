//
//  ITCameraPresenter.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGMediaPickerItem.h"
#import "MAGCamera.h"

typedef void(^PickItemCompletion)(MAGMediaPickerItem *item);


@protocol MAGCameraPresenterProtocol <NSObject>

@property (readonly, nonatomic) MAGCamera *camera;

- (void)actionStartRecording;
- (void)actionStopRecording;
- (void)actionTakePhoto;

- (void)setPickItemCompletion:(PickItemCompletion)completion;
- (void)viewDidLayout;

@end


@interface MAGCameraPresenter : NSObject <MAGCameraPresenterProtocol>

@property (readonly, nonatomic) MAGCamera *camera;
@property(copy, nonatomic) PickItemCompletion pickItemCompletion;

- (instancetype)initWithCameraView:(UIView *)view;

@end
