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


typedef void(^MAGMediaPreviewCompleted)(MAGMediaPickerItem *item);
typedef void(^MAGMediaPreviewCancelled)();


@interface MAGMediaPreviewViewController : UIViewController

@property (strong, nonatomic) id<MAGMediaPickerStringsProtocol> strings;
@property(copy, nonatomic) MAGMediaPreviewCompleted completed;
@property(copy, nonatomic) MAGMediaPreviewCancelled cancelled;

- (void)showRecordSession:(MAGRecordSession *)recordSession;

@end
