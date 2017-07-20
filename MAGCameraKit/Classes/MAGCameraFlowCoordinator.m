//
//  MAGCameraFlowCoordinator.m
//  Pods
//
//  Created by Stepanov Evgeniy on 19/07/2017.
//
//

#import "MAGCameraFlowCoordinator.h"
#import "MAGCameraKitCommon.h"
#import "MAGMediaPreviewPresenter.h"
#import "MAGMediaEditorPresenter.h"
#import "MAGCameraPresenter.h"
#import "MAGMediaPickerPresenter.h"

@interface MAGCameraFlowCoordinator ()

@property (weak, nonatomic) UIViewController<MAGCameraVCProtocol> *cameraVC;
@property (weak, nonatomic) UIViewController<MAGMediaPreviewVCProtocol> *previewVC;
@property (weak, nonatomic) UIViewController<MAGMediaEditorVCProtocol> *editorVC;

@end


@implementation MAGCameraFlowCoordinator



- (void)showMediaPicker:(UIViewController<MAGMediaPickerVCProtocol> *)pickerVC rootVC:(UIViewController *)rootVC completion:(MAGTakeMediaCompletion)completion {
    self.mediaPickerVC = pickerVC;
    
    pickerVC.coordinator = self;
    pickerVC.presenter = [MAGMediaPickerPresenter new];
    pickerVC.presenter.viewController = pickerVC;
    
    [rootVC presentViewController:pickerVC animated:YES completion:nil];
    
    @weakify(self);
    [pickerVC.presenter setCompletion:^(MAGMediaPickerItem *item) {
        @strongify(self);
        [self hideMediaPicker];
        
        if (completion) {
            completion(item);
        }
    }];
    
    //[self configureMediaPickerVC];
}


- (void)hideMediaPicker {
    [self.mediaPickerVC dismissViewControllerAnimated:YES completion:nil];
}


- (void)configureCameraVC:(UIViewController<MAGCameraVCProtocol> *)vc {
    self.cameraVC = vc;
    
    vc.coordinator = self;
    vc.presenter = [MAGCameraPresenter new];
    vc.presenter.viewController = vc;
    
    @weakify(self);
    [self.cameraVC.presenter setCompleted:^(MAGRecordSession *session) {
        @strongify(self);
        //[self.previewVC showRecordSession:session];
        //[self showPreview];
        [self showPreView];
    }];
    
    [self.cameraVC.presenter setCancelled:^() {
        @strongify(self);
        //[self.cameraVC removeRecordedSession];
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self hideCameraView];
    }];

}


- (void)configurePreviewVC:(UIViewController<MAGMediaPreviewVCProtocol> *)vc {
    self.previewVC = vc;
    
    vc.coordinator = self;
    vc.presenter = [MAGMediaPreviewPresenter new];
    vc.presenter.viewController = vc;
    
    @weakify(self);
    [self.previewVC.presenter setCompleted:^(MAGMediaPickerItem *item) {
        @strongify(self);
        //[self.cameraVC removeRecordedSession];
        //if (self.presenter.completion) {
        //    self.presenter.completion(item);
        //}
        
        [self.cameraVC removeRecordedSession];
        if (self.mediaPickerVC.presenter.completion) {
            self.mediaPickerVC.presenter.completion(item);
        }
    }];
    
    [self.previewVC.presenter setCancelled:^() {
        @strongify(self);
        //[self.cameraVC removeRecordedSession];
        //[self hidePreview];
        [self hidePreView];
    }];
    
}


- (void)configureLibraryVC {
    
}


- (void)configureEditorVC:(UIViewController<MAGMediaEditorVCProtocol> *)vc {
    
}





- (void)showCameraView {
    
}

- (void)hideCameraView {
    
}


- (void)showPreView {
    [self.previewVC showRecordSession:session];
}

- (void)hidePreView {
    
}


- (void)showEditView {
    
}

- (void)hideEditView {
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue {
    
    if ([segue.identifier isEqualToString:@"Camera"]) {
        //self.cameraVC = segue.destinationViewController;
        //self.cameraVC.strings = self.strings;
        
        [self configureCameraVC:segue.destinationViewController];
        
    } else if ([segue.identifier isEqualToString:@"Preview"]) {
        //self.previewVC = segue.destinationViewController;
        //self.previewVC.strings = self.strings;
        
        [self configurePreviewVC:segue.destinationViewController];
        
    } else if ([segue.identifier isEqualToString:@"Media"]) {
        //self.mediaVC = segue.destinationViewController;
        //self.mediaVC.strings = self.strings;
    }
}


@end
