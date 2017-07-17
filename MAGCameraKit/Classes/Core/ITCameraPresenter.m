//
//  ITCameraPresenter.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "ITCameraPresenter.h"
#import "MAGCameraKitCommon.h"


@interface ITCameraPresenter ()

@property (strong, nonatomic) ITCamera *camera;

@end


@implementation ITCameraPresenter

- (instancetype)initWithCameraView:(UIView *)view {
    
    if (self = [super init]) {
        self.camera = [ITCamera new];
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
        ITMediaPickerItem *item = nil;
        
        if (image) {
            item = [ITMediaPickerItem new];
            item.type = ITMediaTypeImage;
            item.image = image;
        }
        @strongify(self);
        if (self.pickItemCompletion) {
            self.pickItemCompletion(item);
        }
    }];
}

@end
