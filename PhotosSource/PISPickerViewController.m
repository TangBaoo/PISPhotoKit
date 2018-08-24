//
//  PISPickerViewController.m
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/17.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#define IMGWIDTH (([UIScreen mainScreen].bounds.size.width - 5) / 4)

#import "PISPickerViewController.h"
#import "PISPVHeaderView.h"
#import "PISPhotosCollectionViewCell.h"
#import "PISImageViewController.h"
#import <Photos/Photos.h>
#import "ButtonAnimation.h"
#import "BaseMBProgressView.h"

@interface PISPickerViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    PISPVHeaderView *_pisHeaderView;
    UICollectionView *_collection;
    UICollectionViewFlowLayout *_flowLayout;
    NSMutableArray *_photoList;
    NSMutableArray *_tagArray;
}
@property (nonatomic, strong) BaseMBProgressView *mbView;

@end

@implementation PISPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tagArray = [[NSMutableArray alloc] init];
    
    // 最多9张
    if (!_maxItem || _maxItem > 9) {
        _maxItem = 9;
    }
    
    _photoList = [[NSMutableArray alloc] init];
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 1;
    _flowLayout.minimumInteritemSpacing = 1;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:_flowLayout];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collection];
    
    [_collection registerClass:[PISPhotosCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    // 按图片生成时间排序
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    // 获取图片
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    [allPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [_photoList addObject:obj];
            if (_photoList.count == allPhotos.count) {
                _photoList = (NSMutableArray *)[[_photoList reverseObjectEnumerator] allObjects];
                [_collection reloadData];
            }
        }
    }];
    
    [self createHeaderView];
    
    [self createMBView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 64);
}

- (void)createHeaderView
{
    _pisHeaderView = [[PISPVHeaderView alloc] init];
    [_pisHeaderView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pisHeaderView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PISPhotosCollectionViewCell *cell = [_collection dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.asset = _photoList[indexPath.row];
    [cell.tagButton addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.tagBool = [_tagArray containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(IMGWIDTH, IMGWIDTH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PISImageViewController *vc = [[PISImageViewController alloc] init];
    vc.photoList = _photoList;
    vc.imgIndex = indexPath.row;
    vc.tagArray = _tagArray;
    vc.maxItem = _maxItem;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    
    [vc returnTag:^(NSMutableArray *result) {
        
        if (result) {
            _tagArray = result;
            [self submitState];
            [_collection reloadData];
        }
    }];
    
    // 确定返回
    [vc returnSubmit:^(BOOL result) {
        if (result) {
            [self submitClick];
        }
    }];
    
    [self presentViewController:vc animated:YES completion:nil];
}


// 选择图片
- (void)tagClick:(UIButton *)sender
{
    PISPhotosCollectionViewCell *cell = (PISPhotosCollectionViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_collection indexPathForCell:cell];
    
    if (sender.selected) {
        sender.selected = !sender.selected;
        [_tagArray removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        cell.backGroundView.alpha = 0;
        
    } else {
        
        if (_tagArray.count < _maxItem) {
            sender.selected = !sender.selected;
            [_tagArray addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
            
            ButtonAnimation *animation = [ButtonAnimation new];
            [sender.layer addAnimation:animation forKey:nil];
            cell.backGroundView.alpha = .3;
            
        } else {
            
            [self.mbView disappearMBViewWithText:[NSString stringWithFormat:@"最多选择%ld张",_maxItem]];
        }
    }
    [self submitState];
}

- (void)submitState
{
    if (_tagArray.count) {
        [_pisHeaderView.submitButton setTitle:[NSString stringWithFormat:@"选择(%ld)",_tagArray.count] forState:UIControlStateNormal];
        [_pisHeaderView setOrangeButton];
    } else{
        [_pisHeaderView.submitButton setTitle:@"选择" forState:UIControlStateNormal];
        [_pisHeaderView setNormalButton];
    }
}

// 确定选择
- (void)submitClick
{
    [self.mbView modeIndeterminateWithText:@"处理中"];
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    for (NSString *str in _tagArray) {
        NSInteger index = [str integerValue];
        PHAsset *asset = _photoList[index];
        
        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
        phImageRequestOptions.networkAccessAllowed = YES;   //可自动下载icould云端的图片
        // 是否返回原图 / 还是压缩图
        // PHImageRequestOptionsDeliveryModeHighQualityFormat / PHImageRequestOptionsDeliveryModeOpportunistic
        phImageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:phImageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

            // 因为方法会多次调用 等原图返回才加入数组
            if ([info objectForKey:@"PHImageFileSandboxExtensionTokenKey"]) {

                [imgArray addObject:result];
            }

            if (imgArray.count == _tagArray.count) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mbView removeMBView];
                    if (self.imageArrayBlock != nil) {
                        self.imageArrayBlock(imgArray);
                    }

                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }];
        
//        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:phImageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//
//            // 因为方法会多次调用 等原图返回才加入数组
//            if ([info objectForKey:@"PHImageFileSandboxExtensionTokenKey"]) {
//
//                [imgArray addObject:imageData];
//            }
//
//            if (imgArray.count == _tagArray.count) {
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.mbView removeMBView];
//                    if (self.imageArrayBlock != nil) {
//                        self.imageArrayBlock(imgArray);
//                    }
//
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                });
//            }
//        }];
    }

}

- (void)returnImageArray:(ImageArrayBlock)block
{
    self.imageArrayBlock = block;
}

- (void)createMBView
{
    if (!self.mbView) {
        self.mbView = [BaseMBProgressView new];
    }
    [self.view addSubview:self.mbView.progressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
