//
//  ITMediaLibraryViewController.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 13.12.16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "ITMediaLibraryViewController.h"
#import "ITMediaAssetCell.h"

#import <Photos/Photos.h>


NSInteger const kMaxImageSize = 1920;


@interface ITMediaLibraryViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UILabel *noContentLabel;

@property (strong, nonatomic) PHFetchResult<PHAsset *> *assets;
//@property (copy, nonatomic) NSArray<PHAsset *> *items;

@end


@implementation ITMediaLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = [self.strings mediaLibraryTitle]; //NSLocalizedString(@"camera.medialibrary.title", @"Photo and Video");
    self.noContentLabel.text = [self.strings mediaLibraryNoContent]; //NSLocalizedString(@"camera.medialibrary.empty", @"No photo or video");
}


- (void)loadAssets {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            
            self.assets = [PHAsset fetchAssetsWithOptions:options];
            
            [self showOrHideNoContentLabel];
            [self.collectionView reloadData];
        });
    }];
}


- (void)loadAssetsIfNeed {
    
    if (self.assets.count == 0) {
        [self loadAssets];
    }
}


- (void)showOrHideNoContentLabel {
    
    BOOL hasContent = self.assets.count;
    //self.titleLabel.hidden = !hasContent;
    self.noContentLabel.hidden = hasContent;
}


- (void)itemDidSelect:(PHAsset *)asset {
    
    //ITMediaPickerItem *item = nil;
    if (asset.duration <= self.maxVideoDuration) {
        [self exportMediaAsset:asset completion:^(ITRecordSession *item) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.selectedMediaItem) {
                    self.selectedMediaItem(item);
                }
            });
        }];
        
    } else {
        [self showAlertVideoDurationIsExceed];
    }
    
}


- (void)showAlertVideoDurationIsExceed {
    
    NSString *message = [self.strings mediaLibraryAddingExceedSize]; //NSLocalizedString(@"camera.medialibrary.exceed", @"Selected video should not exceed %li seconds");
    message = [NSString stringWithFormat:message, (long)@(self.maxVideoDuration).integerValue];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[self.strings mediaLibraryButtonOk] /*NSLocalizedString(@"alert.ok_button", nil)*/ style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)exportMediaAsset:(PHAsset *)asset completion:(nonnull void(^)(ITRecordSession *item))completion {
    
    ITRecordSession *mediaItem = [ITRecordSession new];
    
    if (asset.mediaType == PHAssetMediaTypeImage) {
        
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.networkAccessAllowed = YES;
        requestOptions.synchronous = NO;
        

        
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:CGSizeMake(kMaxImageSize, kMaxImageSize)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:requestOptions
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    
                                                    if (result) {
                                                        mediaItem.photoImage = result;
                                                        completion(mediaItem);
                                                    }
                                                }];
        
    } else if (asset.mediaType == PHAssetMediaTypeVideo) {
        
        PHVideoRequestOptions *requestOptions = [[PHVideoRequestOptions alloc] init];
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.networkAccessAllowed = YES;

        
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset
                                                        options:requestOptions
                                                  resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                                      
                                                      if (asset) {
                                                          mediaItem.videoAsset = asset;
                                                          completion(mediaItem);
                                                      }
                                                  }];
    } else {
        completion(nil);
    }
    
}


#pragma mark - <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ITMediaAssetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ITMediaAssetCell class]) forIndexPath:indexPath];
    
    PHAsset *asset = self.assets[indexPath.row];
    [cell configure:asset];
    
    return cell;
}


#pragma mark - <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = self.assets[indexPath.row];
    [self itemDidSelect:asset];
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (NSIndexPath *item in [collectionView indexPathsForSelectedItems]) {
        if (![item isEqual:indexPath]) {
            [collectionView deselectItemAtIndexPath:item animated:YES];
        }
    }
}



@end
