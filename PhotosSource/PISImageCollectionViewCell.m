//
//  PISImageCollectionViewCell.m
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/22.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#import "PISImageCollectionViewCell.h"
#import "PISImageViewController.h"


@interface PISImageCollectionViewCell() <UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView  *scrollView;
@property (nonatomic, strong)UIImageView *imgView;

@end

@implementation PISImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self scrollView];
        [self imgView];
    }
    return self;
}

#pragma mark- getter
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        [self.contentView addSubview:_scrollView];
        
        // 双击手势
        UITapGestureRecognizer *doubelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGesture:)];
        doubelGesture.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubelGesture];
        
        // 单击手势
        UITapGestureRecognizer *oneGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneGesture:)];
        oneGesture.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:oneGesture];
        
        // 只有双击手势失败时 才识别单击手势
        [oneGesture requireGestureRecognizerToFail:doubelGesture];

    }
    return _scrollView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:_imgView];
    }
    
    return _imgView;
}

- (void)setAsset:(PHAsset *)asset
{
    if (_asset != asset) {
        _asset = asset;
        
        // 按图片比例决定取图片的宽高
        CGSize assetSize = CGSizeZero;
        if (_asset.pixelWidth < _asset.pixelHeight) {
            assetSize = [UIScreen mainScreen].bounds.size;
        } else {
            assetSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        }
        
        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
        phImageRequestOptions.networkAccessAllowed = YES;
        phImageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        
        [[PHImageManager defaultManager] requestImageForAsset:_asset targetSize:assetSize contentMode:PHImageContentModeAspectFit options:phImageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            _imgView.image = result;
            CGSize maxSize = self.scrollView.frame.size;
            CGFloat widthRatio = maxSize.width / result.size.width;
            CGFloat heightRatio = maxSize.height / result.size.height;
            CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
            
            if (initialZoom > 1) {
                initialZoom = 1;
            }
            
            CGRect r = self.scrollView.frame;
            r.size.width = result.size.width * initialZoom;
            r.size.height = result.size.height * initialZoom;
            if (result.size.width < 200) {
                self.imgView.frame = self.scrollView.frame;
            } else {
                self.imgView.frame = r;
            }
            self.imgView.center = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2);
            
            [self.scrollView setMinimumZoomScale:1];
            [self.scrollView setMaximumZoomScale:5];
            [self.scrollView setZoomScale:1.0];
        }];
    }
}


#pragma mark- scroll手势
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (view.frame.size.width < [UIScreen mainScreen].bounds.size.width) {
        _imgView.frame = _scrollView.frame;
        _imgView.center = CGPointMake(_scrollView.frame.size.width / 2, _scrollView.frame.size.height / 2);
    }
}

// 双击 缩放
- (void)doubleGesture:(UITapGestureRecognizer *)sender
{
    
    if (_scrollView.zoomScale > 1) {
        [_scrollView zoomToRect:_scrollView.frame animated:YES];
        return;
    }
    if (_scrollView.zoomScale == 1) {

        CGRect zoomRect = [self zoomRectForScale:5 withCenter:[sender locationInView:_imgView]];
        [_scrollView zoomToRect:zoomRect animated:YES];
        return;
    }
    
}

// 单击 退出
- (void)oneGesture:(UITapGestureRecognizer *)sender
{
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[PISImageViewController class]]) {
            UIViewController *controller = (UIViewController *)nextResponder ;
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


@end
