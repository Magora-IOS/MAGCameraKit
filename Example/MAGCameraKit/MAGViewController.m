//
//  MAGViewController.m
//  MAGCameraKit
//
//  Created by Stepanov Evgeniy on 07/06/2017.
//  Copyright (c) 2017 Stepanov Evgeniy. All rights reserved.
//

#import "MAGViewController.h"
#import "ITMediaPicker.h"


@interface MAGViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) ITMediaPicker *mediaPicker;

@end


@implementation MAGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.mediaPicker = [[ITMediaPicker alloc] initWithVC:self];
}

- (IBAction)captureAction:(id)sender {
    
    [self.mediaPicker pickMedia:^(ITMediaPickerItem *item) {
        if (item.type == ITMediaTypeImage) {
            self.imageView.image = item.image;
        }
    }];
}

@end
