//
//  MAGMediaEditorPresenter.h
//  Pods
//
//  Created by Stepanov Evgeniy on 19/07/2017.
//
//

#import <Foundation/Foundation.h>


@class MAGMediaEditorPresenter;
@class MAGCameraFlowCoordinator;

@protocol MAGMediaEditorVCProtocol <NSObject>

@property (strong, nonatomic) MAGMediaEditorPresenter *presenter;
@property (strong, nonatomic) MAGCameraFlowCoordinator *coordinator;

@end


@interface MAGMediaEditorPresenter : NSObject

@property (weak, nonatomic) UIViewController<MAGMediaEditorVCProtocol> *viewController;

@end
