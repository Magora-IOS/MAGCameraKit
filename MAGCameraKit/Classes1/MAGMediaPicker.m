//
//  ITMediaPicker.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 01/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGMediaPicker.h"
#import "ITCameraViewController.h"
#import "ITMediaPickerViewController.h"
#import "MAGCameraKitCommon.h"


@interface MAGMediaPicker ()
@property (weak, nonatomic) UIViewController *ownerVC;
@end


@implementation MAGMediaPicker


- (instancetype)initWithVC:(UIViewController *)vc {
    if (self = [super init]) {
        self.ownerVC = vc;
    }
    
    return self;
}



- (void)pickMedia:(PickedMediaItem)completion {
    ITMediaPickerViewController *cameraVC = [self loadCameraVC];
    cameraVC.presenter = [ITMediaPickerPresenter new];
    cameraVC.strings = self.strings;
    
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
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CameraFlow" bundle:bundle];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    return (ITMediaPickerViewController *)vc;
}


@end
