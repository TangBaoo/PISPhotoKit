//
//  PISPhotosCollectionViewCell.m
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/22.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#define IMGWIDTH (([UIScreen mainScreen].bounds.size.width - 5) / 4)
#define IMGSIZE (CGSizeMake(250, 250))

#import "PISPhotosCollectionViewCell.h"

@interface PISPhotosCollectionViewCell()

@property (nonatomic, strong)UIImageView *imgView;

@end

@implementation PISPhotosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMGWIDTH, IMGWIDTH)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        _imgView.clipsToBounds = YES;
        _imgView.userInteractionEnabled = YES;
        
        self.backGroundView = [[UIView alloc] initWithFrame:_imgView.frame];
        _backGroundView.backgroundColor = [UIColor blackColor];
        _backGroundView.alpha = 0;
        [self.contentView addSubview:_backGroundView];
        
        _tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tagButton.frame = CGRectMake(IMGWIDTH - 35, 5, 30, 30);
        [_tagButton setImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
        [_tagButton setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateSelected];
        [self.contentView addSubview:_tagButton];
    }
    return self;
}

- (void)setAsset:(PHAsset *)asset
{
    if (_asset != asset) {
        _asset = asset;
        
        [[PHImageManager defaultManager] requestImageForAsset:_asset targetSize:IMGSIZE contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            _imgView.image = result;
        }];
    }
}

- (void)setTagBool:(BOOL)tagBool
{
    _tagBool = tagBool;
    if (tagBool) {
        _tagButton.selected = YES;
        _backGroundView.alpha = .3;
    } else {
        _tagButton.selected = NO;
        _backGroundView.alpha = 0;
    }
}


@end
