//
//  ITMediaLibraryViewController.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 13.12.16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGMediaPickerItem.h"
#import "MAGRecordSession.h"
#import "MAGMediaPickerStringsProtocol.h"


typedef void(^SelectedMediaItem)(MAGRecordSession *session);

@interface MAGMediaLibraryViewController : UIViewController

@property (strong, nonatomic) id<MAGMediaPickerStringsProtocol> strings;
@property(copy, nonatomic) SelectedMediaItem selectedMediaItem;
@property(assign, nonatomic) CGFloat maxVideoDuration;

- (void)loadAssets;
- (void)loadAssetsIfNeed;

@end
