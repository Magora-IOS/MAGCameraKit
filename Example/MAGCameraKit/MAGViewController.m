//
//  MAGViewController.m
//  MAGCameraKit
//
//  Created by Stepanov Evgeniy on 07/06/2017.
//  Copyright (c) 2017 Stepanov Evgeniy. All rights reserved.
//

#import "MAGViewController.h"
#import "MAGCameraKit.h"
#import "MAGMediaPickerStrings.h"
//#import "ITMediaPicker.h"


@interface MAGViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) MAGMediaPicker *mediaPicker;

@end


@implementation MAGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.mediaPicker = [[MAGMediaPicker alloc] initWithVC:self];
    self.mediaPicker.strings = [MAGMediaPickerStrings new];
}

- (IBAction)captureAction:(id)sender {
    
    [self.mediaPicker pickMedia:^(MAGMediaPickerItem *item) {
        if (item.type == MAGMediaTypeImage) {
            self.imageView.image = item.image;
        }
    }];
}

@end
