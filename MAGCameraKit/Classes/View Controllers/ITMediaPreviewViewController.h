//
//  ITCameraPreviewViewController.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 05/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITRecordSession.h"
#import "ITMediaPickerItem.h"
#import "MAGMediaPickerStringsProtocol.h"


typedef void(^ITMediaPreviewCompleted)(ITMediaPickerItem *item);
typedef void(^ITMediaPreviewCancelled)();


@interface ITMediaPreviewViewController : UIViewController

@property (strong, nonatomic) id<MAGMediaPickerStringsProtocol> strings;
@property(copy, nonatomic) ITMediaPreviewCompleted completed;
@property(copy, nonatomic) ITMediaPreviewCancelled cancelled;

- (void)showRecordSession:(ITRecordSession *)recordSession;

@end
