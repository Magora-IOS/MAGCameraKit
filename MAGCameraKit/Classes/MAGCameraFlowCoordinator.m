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
#import <SVProgressHUD/SVProgressHUD.h>

@interface MAGCameraFlowCoordinator ()

@property (weak, nonatomic) UIViewController<MAGMediaPickerVCProtocol> *mediaPickerVC;
@property (weak, nonatomic) UIViewController<MAGCameraVCProtocol> *cameraVC;
@property (weak, nonatomic) UIViewController<MAGMediaPreviewVCProtocol> *previewVC;
@property (weak, nonatomic) UIViewController<MAGMediaEditorVCProtocol> *editorVC;

@end


@implementation MAGCameraFlowCoordinator



- (void)configureMediaPicker:(UIViewController<MAGMediaPickerVCProtocol> *)pickerVC completion:(MAGTakeMediaCompletion)completion {
    self.mediaPickerVC = pickerVC;
    
    pickerVC.coordinator = self;
    pickerVC.presenter = [MAGMediaPickerPresenter new];
    pickerVC.presenter.viewController = pickerVC;
    
    @weakify(self);
    [pickerVC.presenter setCompletion:^(MAGMediaPickerItem *item) {
        @strongify(self);
        [self hideMediaPicker];
        
        if (completion) {
            completion(item);
        }
    }];
    
    [pickerVC.presenter setCancellation:^() {
        @strongify(self);
        [self hideMediaPicker];
    }];
}


- (void)showMediaPicker:(UIViewController *)rootVC {
    [rootVC presentViewController:self.mediaPickerVC animated:YES completion:nil];
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
        //[self showPreview];
        [self.cameraVC showPreview];
        [self.previewVC.presenter openRecordSession:session];
    }];
    
    [self.cameraVC.presenter setCancelled:^() {
        @strongify(self);
        [self.cameraVC.presenter removeRecordedSession];
        [self.mediaPickerVC.presenter cancelAction];
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
        
        [self.cameraVC.presenter removeRecordedSession];
        [self.mediaPickerVC.presenter completeActionWithItem:item];
    }];
    
    [self.previewVC.presenter setCancelled:^() {
        @strongify(self);
        [self.cameraVC.presenter removeRecordedSession];
        [self.cameraVC hidePreview];
        //[self hidePreview];
    }];
    
}


- (void)configureLibraryVC {
    
}


- (void)configureEditorVC:(UIViewController<MAGMediaEditorVCProtocol> *)vc {
    self.editorVC = vc;
    
    vc.coordinator = self;
    vc.presenter = [MAGMediaEditorPresenter new];
    vc.presenter.viewController = vc;
    self.previewVC.presenter.editorPresenter = vc.presenter;
    
    [self.editorVC.presenter setCompleted:^() {
        [self.previewVC.presenter showControls];
    }];
    
    [self.editorVC.presenter setCancelled:^() {
        [self.previewVC.presenter showControls];
    }];
    
    //[self setupTrackShowingTrash];
}

/*
- (void)setupTrackShowingTrash {
    
    @weakify(self);
    [self.editorVC.presenter trackShowingTrash:^(BOOL show) {
        @strongify(self);
        
        if (show) {
            [self.previewVC hideCompleteButton];
        } else {
            [self.previewVC showCompleteButton];
        }
    }];
}
*/

/*
- (void)showPreview:(MAGRecordSession *)session {
    [self.cameraVC showPreview];
    [self.previewVC.presenter openRecordSession:session];
}

- (void)hidePreview {
    [self.cameraVC hidePreview];
}
*/
/*
- (void)showEditView {
    
}

- (void)hideEditView {
    
}
*/


- (void)openTextEdit {
    [self.previewVC.presenter hideControls];
    [self.editorVC.presenter openTextEdit];
}


- (void)openPaintEdit {
    [self.previewVC.presenter hideControls];
    [self.editorVC.presenter openPaintEdit];
}


- (void)openEmojiEdit {
    [self.previewVC.presenter hideControls];
    [self.editorVC.presenter openEmojiEdit];
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
        
    } else if ([segue.identifier isEqualToString:@"Editor"]) {
        [self configureEditorVC:segue.destinationViewController];
    }
}


@end
