//
//  BaseMBProgressView.m
//  Master
//
//  Created by ConnorJ on 15/11/23.
//  Copyright © 2015年 PutiBaby. All rights reserved.
//

#import "BaseMBProgressView.h"

@implementation BaseMBProgressView

- (MBProgressHUD *)progressView
{
    if (!_progressView) {
        _progressView = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    }
    return _progressView;
}

- (void)disappearMBViewWithText:(NSString *)text
{
    [self.progressView showAnimated:YES];
    [self.progressView setMode:MBProgressHUDModeText];
    self.progressView.label.text = text;
    [self.progressView hideAnimated:YES afterDelay:1];
}

- (void)modeIndeterminateWithText:(NSString *)text
{
    [self.progressView showAnimated:YES];
    [self.progressView setMode:MBProgressHUDModeIndeterminate];
    self.progressView.label.text = text;
}

- (void)removeMBView {
    [self.progressView hideAnimated:YES];
}

@end
