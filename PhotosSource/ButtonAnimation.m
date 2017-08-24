//
//  ButtonAnimation.m
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/24.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#import "ButtonAnimation.h"

@implementation ButtonAnimation

- (instancetype)init
{
    if (self = [super init]) {
        // button点击抖动动画
        self.keyPath = @"transform";
        self.duration = 0.5;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        self.values = values;
    }
    return self;
}

@end
