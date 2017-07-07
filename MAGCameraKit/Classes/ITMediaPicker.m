//
//  ITMediaPicker.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 01/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "ITMediaPicker.h"
#import "ITCameraViewController.h"
#import "ITMediaPickerViewController.h"


@interface ITMediaPicker ()
@property (weak, nonatomic) UIViewController *ownerVC;
@end


@implementation ITMediaPicker


- (instancetype)initWithVC:(UIViewController *)vc {
    if (self = [super init]) {
        self.ownerVC = vc;
    }
    
    return self;
}



- (void)pickMedia:(PickedMediaItem)completion {
    ITMediaPickerViewController *cameraVC = [self loadCameraVC];
    cameraVC.presenter = [ITMediaPickerPresenter new];
    
    [self.ownerVC presentViewController:cameraVC animated:YES completion:nil];

    @weakify(cameraVC);
    [cameraVC.presenter setCompletion:^(ITMediaPickerItem *item) {
        @strongify(cameraVC);
        [cameraVC dismissViewControllerAnimated:YES completion:nil];

        if (completion) {
            completion(item);
        }
    }];
}


- (ITMediaPickerViewController *)loadCameraVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CameraFlow" bundle:nil];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    return (ITMediaPickerViewController *)vc;
}


@end
