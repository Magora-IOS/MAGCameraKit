//
//  ITCameraPresenter.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITMediaPickerItem.h"
#import "ITCamera.h"

typedef void(^PickItemCompletion)(ITMediaPickerItem *item);


@protocol ITCameraPresenterProtocol <NSObject>

@property (readonly, nonatomic) ITCamera *camera;

- (void)actionStartRecording;
- (void)actionStopRecording;
- (void)actionTakePhoto;

- (void)setPickItemCompletion:(PickItemCompletion)completion;
- (void)viewDidLayout;

@end


@interface ITCameraPresenter : NSObject <ITCameraPresenterProtocol>

@property (readonly, nonatomic) ITCamera *camera;
@property(copy, nonatomic) PickItemCompletion pickItemCompletion;

- (instancetype)initWithCameraView:(UIView *)view;

@end
