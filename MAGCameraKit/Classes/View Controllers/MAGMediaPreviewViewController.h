//
//  ITCameraPreviewViewController.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 05/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGRecordSession.h"
#import "MAGMediaPickerItem.h"
#import "MAGMediaPickerStringsProtocol.h"
#import "MAGMediaPreviewPresenter.h"



@interface MAGMediaPreviewViewController : UIViewController <MAGMediaPreviewVCProtocol>

@property (strong, nonatomic) MAGMediaPreviewPresenter *presenter;
@property (strong, nonatomic) MAGCameraFlowCoordinator *coordinator;
@property (strong, nonatomic) id<MAGMediaPickerStringsProtocol> strings;

- (void)showRecordSession:(MAGRecordSession *)recordSession;

@end
