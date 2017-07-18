//
//  ITCameraPresenter.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGCameraPresenter.h"
#import "MAGCameraKitCommon.h"


@interface MAGCameraPresenter ()

@property (strong, nonatomic) MAGCamera *camera;

@end


@implementation MAGCameraPresenter

- (instancetype)initWithCameraView:(UIView *)view {
    
    if (self = [super init]) {
        self.camera = [MAGCamera new];
        self.camera.cameraView = view;
    }
    
    return self;
}


- (void)viewDidLayout {
    [self.camera layoutCameraLayer];
}


- (void)actionStartRecording {
    [self.camera startRecording:^(AVAsset *asset) {
        //
    }];
}

- (void)actionStopRecording {
    [self.camera stopRecording];
}

- (void)actionTakePhoto {
    @weakify(self);
    [self.camera takePhoto:^(UIImage *image) {
        MAGMediaPickerItem *item = nil;
        
        if (image) {
            item = [MAGMediaPickerItem new];
            item.type = MAGMediaTypeImage;
            item.image = image;
        }
        @strongify(self);
        if (self.pickItemCompletion) {
            self.pickItemCompletion(item);
        }
    }];
}

@end
