//
//  ITCameraFlowCoordinator.m
//  InTouch
//
//  Created by YuriyPoluektov on 23.03.17.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "ITCameraFlowCoordinator.h"
#import "ITMediaPickerViewController.h"

@interface ITCameraFlowCoordinator ()

@property (strong, nonatomic) ITEvent *event;
//@property (strong, nonatomic) id<ITMediaPickerPresenterProtocol> mediaPickerPresenter;

@end


@implementation ITCameraFlowCoordinator

- (instancetype)initWithRouter:(ITNavigationRouter *)router event:(ITEvent *)event {
    if (self = [super init]) {
        self.baseRouter = router;
        self.router = router;
        self.event = event;
    }
    return self;
}


- (void)start {
    [self openMediaPickerViewController];
}


- (void)openMediaPickerViewController {
    
    ITMediaPickerViewController *mediaPickerVC = [ITMediaPickerViewController instantiateFromStoryboard:CameraFlow];
    mediaPickerVC.presenter.viewController = mediaPickerVC;
    mediaPickerVC.presenter.event = self.event;
    
    [self.router presentViewController:mediaPickerVC animated:YES];
    
    @weakify(mediaPickerVC);
    [mediaPickerVC.presenter setCompletion:^(ITMediaPickerItem *item) {
        @strongify(mediaPickerVC);
        [mediaPickerVC dismissViewControllerAnimated:YES completion:nil];
        
        [mediaPickerVC.presenter uploadMedia:item];
        //if (completion) {
        //    completion(item);
        //}
    }];
}


@end
