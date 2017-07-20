//
//  ITMediaPicker.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 01/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGMediaPicker.h"
#import "MAGCameraViewController.h"
#import "MAGMediaPickerViewController.h"
#import "MAGMediaPickerPresenter.h"
#import "MAGCameraKitCommon.h"


@interface MAGMediaPicker ()
@property (weak, nonatomic) UIViewController *rootVC;
@property (strong, nonatomic) MAGCameraFlowCoordinator *coordinator;
@end


@implementation MAGMediaPicker


- (instancetype)initWithRootVC:(UIViewController *)vc coordinator:( MAGCameraFlowCoordinator *)coordinator {
    if (self = [super init]) {
        self.rootVC = vc;
        self.coordinator = coordinator;
        
        if (self.coordinator == nil) {
            self.coordinator = [MAGCameraFlowCoordinator new];
        }
    }
    
    return self;
}


- (void)pickMedia:(PickedMediaItem)completion {
    MAGMediaPickerViewController *pickerVC = [self loadCameraVC];
    
    [self.coordinator showMediaPicker:pickerVC rootVC:self.rootVC completion:^(MAGMediaPickerItem *item) {
        if (completion) {
            completion(item);
        }
    }];
    
    /*
    pickerVC.presenter = [MAGMediaPickerPresenter new];
    pickerVC.presenter.viewController = pickerVC;
    pickerVC.strings = self.strings;
    
    [self.rootVC presentViewController:pickerVC animated:YES completion:nil];
    
    @weakify(pickerVC);
    [pickerVC.presenter setCompletion:^(MAGMediaPickerItem *item) {
        @strongify(pickerVC);
        [pickerVC dismissViewControllerAnimated:YES completion:nil];
        
        if (completion) {
            completion(item);
        }
    }];
    */
}


- (void)pickMedia1:(PickedMediaItem)completion {
    MAGMediaPickerViewController *cameraVC = [self loadCameraVC];
    cameraVC.presenter = [MAGMediaPickerPresenter new];
    cameraVC.presenter.viewController = cameraVC;
    cameraVC.strings = self.strings;
    
    [self.rootVC presentViewController:cameraVC animated:YES completion:nil];

    @weakify(cameraVC);
    [cameraVC.presenter setCompletion:^(MAGMediaPickerItem *item) {
        @strongify(cameraVC);
        [cameraVC dismissViewControllerAnimated:YES completion:nil];

        if (completion) {
            completion(item);
        }
    }];
}


- (MAGMediaPickerViewController *)loadCameraVC {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CameraFlow" bundle:bundle];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    return (MAGMediaPickerViewController *)vc;
}


@end
