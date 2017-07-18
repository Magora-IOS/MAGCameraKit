//
//  ITColorsPanelViewController.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 12/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "MAGColorsPanelViewController.h"
#import "MAGColorsPanelCell.h"
#import "MAGColorsPanelDataSource.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MAGColorsPanelViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) id<MAGColorsPanelDataSourceProtocol> colorsDataSource;
//@property (strong, nonatomic) UISelectionFeedbackGenerator *feedbackGenerator;

@end


@implementation MAGColorsPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorsDataSource = [MAGColorsPanelDataSource new];
    [self.colorsDataSource loadItems];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.collectionView reloadData];
}


- (void)selectDefaultColor {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.colorsDataSource numberOfColors];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MAGColorsPanelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MAGColorsPanelCell class]) forIndexPath:indexPath];
    
    UIColor *color = [self.colorsDataSource colorByIndex:indexPath.row].color;
    [cell configure:color];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIColor *color = [self.colorsDataSource colorByIndex:indexPath.row].color;
    
    AudioServicesPlaySystemSoundWithCompletion(1520, ^{
        //
    });
    
    //UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    //[feedbackGenerator prepare];
    //[feedbackGenerator impactOccurred];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //[self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    if (self.didSelectColor) {
        self.didSelectColor(color);
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame) / 7, (CGRectGetHeight(collectionView.frame)));
}


@end
