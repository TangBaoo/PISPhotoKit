//
//  PISPickerViewController.h
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/17.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ImageArrayBlock)(NSMutableArray *result);
@interface PISPickerViewController : UIViewController

@property (nonatomic, assign)NSInteger maxItem;

@property (nonatomic, copy) ImageArrayBlock imageArrayBlock;
- (void)returnImageArray:(ImageArrayBlock)block;

@end
