//
//  ITColorsPanelViewController.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 12/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MAGDidSelectColor)(UIColor *color);


@interface MAGColorsPanelViewController : UIViewController

@property (copy, nonatomic) MAGDidSelectColor didSelectColor;

- (void)selectDefaultColor;

@end
