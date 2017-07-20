//
//  ITMediaPickerViewController.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGMediaPickerPresenter.h"
#import "MAGMediaPickerStringsProtocol.h"


@class MAGCameraFlowCoordinator;
@class MAGMediaPickerPresenter;

@interface MAGMediaPickerViewController : UIViewController <MAGMediaPickerVCProtocol>

@property (strong, nonatomic) MAGCameraFlowCoordinator *coordinator;
@property (strong, nonatomic) MAGMediaPickerPresenter *presenter;
@property (strong, nonatomic) id<MAGMediaPickerStringsProtocol> strings;

@end
