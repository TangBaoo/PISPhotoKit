//
//  BaseMBProgressView.h
//  Master
//
//  Created by ConnorJ on 15/11/23.
//  Copyright © 2015年 PutiBaby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseMBProgressView : UIView
@property (nonatomic, strong) MBProgressHUD *progressView;

- (void)disappearMBViewWithText:(NSString *)text;
- (void)modeIndeterminateWithText:(NSString *)text;
- (void)removeMBView;

@end
