//
//  PISImageHeaderView.h
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/23.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PISImageHeaderView : UIView

@property (nonatomic, strong)UILabel *numberLable;
@property (nonatomic, strong)UIButton *submitButton;

- (void)setNormalButton;
- (void)setOrangeButton;

@end
