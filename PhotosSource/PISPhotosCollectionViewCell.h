//
//  PISPhotosCollectionViewCell.h
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/22.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PISPhotosCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) PHAsset *asset;
@property (nonatomic, strong) UIView *backGroundView; // 蒙层
@property (nonatomic, strong) UIButton *tagButton;

@property (nonatomic, assign) BOOL tagBool;

@end
