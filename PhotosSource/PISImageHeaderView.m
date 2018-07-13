//
//  PISImageHeaderView.m
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/23.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#define SELFHEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)

#import "PISImageHeaderView.h"
#import "PISImageViewController.h"


@implementation PISImageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44 + SELFHEIGHT);
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(.5, .5);
        self.layer.shadowOpacity = .5;
        self.alpha = .95;
        
        self.numberLable = [[UILabel alloc] initWithFrame:CGRectMake(0, SELFHEIGHT + 2, [UIScreen mainScreen].bounds.size.width, 42)];
        _numberLable.textColor = [UIColor blackColor];
        _numberLable.font = [UIFont boldSystemFontOfSize:16];
        _numberLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numberLable];

        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(10, 10 + SELFHEIGHT, 60, 26);
        [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:cancelButton];
        [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 10 + SELFHEIGHT, 50, 26);
        [_submitButton setBackgroundColor:[UIColor whiteColor]];
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _submitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _submitButton.layer.borderWidth = .3;
        _submitButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _submitButton.userInteractionEnabled = NO;
        [self addSubview:_submitButton];
        
    }
    return self;
}

// 返回
- (void)cancelAction
{
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[PISImageViewController class]]) {
            UIViewController *controller = (UIViewController *)nextResponder ;
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)setNormalButton
{
    [_submitButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _submitButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 10 + SELFHEIGHT, 50, 26);
    [_submitButton setBackgroundColor:[UIColor whiteColor]];
    _submitButton.userInteractionEnabled = NO;
}

- (void)setOrangeButton
{
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 10 + SELFHEIGHT, 70, 26);
    [_submitButton setBackgroundColor:[UIColor colorWithRed:0.95 green:0.46 blue:0.04 alpha:1.00]];
    _submitButton.userInteractionEnabled = YES;
}

@end
