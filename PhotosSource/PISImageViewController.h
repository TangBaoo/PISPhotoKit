//
//  PISImageViewController.h
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/22.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void (^TagClickBlock)(NSMutableArray *result);
typedef void (^SubmitClickBlock)(BOOL result);

@interface PISImageViewController : UIViewController

@property (nonatomic, copy)NSMutableArray *photoList;
@property (nonatomic, assign)NSInteger imgIndex;

@property (nonatomic, assign)NSInteger maxItem;

@property (nonatomic, strong)NSMutableArray *tagArray;

@property (nonatomic, copy) TagClickBlock tagClickBlock;
- (void)returnTag:(TagClickBlock)block;

@property (nonatomic, copy) SubmitClickBlock submitClickBlock;
- (void)returnSubmit:(SubmitClickBlock)block;

@end
