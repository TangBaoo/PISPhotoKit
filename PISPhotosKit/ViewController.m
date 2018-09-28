//
//  ViewController.m
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/17.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#define IMGWIDTH (([UIScreen mainScreen].bounds.size.width - 8) / 3)

#import "ViewController.h"
#import "PISPickerViewController.h"
#import "DemoCollectionViewCell.h"
#import <Photos/Photos.h>

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UICollectionView *_collection;
    UICollectionViewFlowLayout *_flowLayout;
}

@property (nonatomic, strong)NSMutableArray *imgArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imgArray = [[NSMutableArray alloc] init];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 80, 170, 160, 40);
    submitButton.backgroundColor = [UIColor grayColor];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"进入相册" forState:UIControlStateNormal];
    submitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:submitButton];
    [submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];

    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 2;
    _flowLayout.minimumInteritemSpacing = 2;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 220, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 120) collectionViewLayout:_flowLayout];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collection];
    
    [_collection registerClass:[DemoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)submitAction
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if (status == PHAuthorizationStatusAuthorized) {
            //code
            dispatch_async(dispatch_get_main_queue(), ^{
                
                PISPickerViewController *vc = [[PISPickerViewController alloc] init];
                
                [self presentViewController:vc animated:YES completion:^{
                    
                }];
                
                [vc returnImageArray:^(NSMutableArray *result) {
                    
                    self.imgArray = result;
                    
                    [_collection reloadData];
                    
                }];
            });
        }
    }];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCollectionViewCell *cell = [_collection dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.PhotoImage = _imgArray[indexPath.row];
//    cell.PhotoImage = [UIImage imageWithData:_imgArray[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(IMGWIDTH, IMGWIDTH);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
