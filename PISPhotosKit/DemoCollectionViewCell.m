//
//  DemoCollectionViewCell.m
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/24.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//
#define IMGWIDTH (([UIScreen mainScreen].bounds.size.width - 8) / 3)

#import "DemoCollectionViewCell.h"

@implementation DemoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMGWIDTH, IMGWIDTH)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        _imgView.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhotoImage:(UIImage *)PhotoImage
{
    if (_PhotoImage != PhotoImage) {
        _PhotoImage = PhotoImage;
        _imgView.image = _PhotoImage;
    }
}

@end
