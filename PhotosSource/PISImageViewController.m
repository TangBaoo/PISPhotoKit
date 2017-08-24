//
//  PISImageViewController.m
//  PISPhotosKit
//
//  Created by 灌汤包的大蒸笼 on 2017/8/22.
//  Copyright © 2017年 灌汤包的大蒸笼. All rights reserved.
//

#define TAGWIDTH (40)

#import "PISImageViewController.h"
#import "PISImageCollectionViewCell.h"
#import "PISImageHeaderView.h"
#import "ButtonAnimation.h"
#import "BaseMBProgressView.h"

@interface PISImageViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    UICollectionView *_collection;
    UICollectionViewFlowLayout *_flowLayout;
    PISImageHeaderView *_pisHeaderView;
    UIButton *_tagButton;
}
@property (nonatomic, strong) BaseMBProgressView *mbView;

@end

@implementation PISImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(-5, 64, [UIScreen mainScreen].bounds.size.width + 10, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:_flowLayout];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    _collection.pagingEnabled = YES;
    _collection.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collection];
    
    [_collection registerClass:[PISImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [_collection setContentOffset:CGPointMake(_imgIndex * ([UIScreen mainScreen].bounds.size.width + 10), 0)];
    
    [self createHeaderView];
    
    [self createTagButton];
    [self submitState];
    
    [self createMBView];
}

- (void)createHeaderView
{
    _pisHeaderView = [[PISImageHeaderView alloc] init];
    [_pisHeaderView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pisHeaderView];
    _pisHeaderView.numberLable.text = [NSString stringWithFormat:@"%ld/%ld",_imgIndex + 1,_photoList.count];
}

- (void)createTagButton
{
    _tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _tagButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 79, TAGWIDTH, TAGWIDTH);
    [_tagButton setImage:[UIImage imageNamed:@"未选择"] forState:UIControlStateNormal];
    [_tagButton setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateSelected];
    [_tagButton addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tagButton];
    
    
    if ([_tagArray containsObject:[NSString stringWithFormat:@"%.0f",_collection.contentOffset.x / ([UIScreen mainScreen].bounds.size.width + 10)]]) {
        _tagButton.selected = YES;
    } else {
        _tagButton.selected = NO;
    }
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
    PISImageCollectionViewCell *cell = [_collection dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.asset = _photoList[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width + 10, [UIScreen mainScreen].bounds.size.height - 64);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _collection) {
        _pisHeaderView.numberLable.text = [NSString stringWithFormat:@"%.0f/%ld",_collection.contentOffset.x / ([UIScreen mainScreen].bounds.size.width + 10) + 1,_photoList.count];
        
        if ([_tagArray containsObject:[NSString stringWithFormat:@"%.0f",_collection.contentOffset.x / ([UIScreen mainScreen].bounds.size.width + 10)]]) {
            _tagButton.selected = YES;
        } else {
            _tagButton.selected = NO;
        }
    }
}



// 选择图片
- (void)tagClick:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected = !sender.selected;
        
        [_tagArray removeObject:[NSString stringWithFormat:@"%.0f",_collection.contentOffset.x / ([UIScreen mainScreen].bounds.size.width + 10)]];
        
    } else {
        if (_tagArray.count < _maxItem) {
            sender.selected = !sender.selected;
            
        
            [_tagArray addObject:[NSString stringWithFormat:@"%.0f",_collection.contentOffset.x / ([UIScreen mainScreen].bounds.size.width + 10)]];
            
            ButtonAnimation *animation = [ButtonAnimation new];
            [sender.layer addAnimation:animation forKey:nil];
            
        } else {
            
            [self.mbView disappearMBViewWithText:[NSString stringWithFormat:@"最多选择%ld张",_maxItem]];
        }
    }
    
    if (self.tagClickBlock != nil) {
        self.tagClickBlock(_tagArray);
    }
    
    [self submitState];
}

// 回调选择图票Block
- (void)returnTag:(TagClickBlock)block
{
    self.tagClickBlock = block;
}

- (void)submitState
{
    if (_tagArray.count) {
        [_pisHeaderView.submitButton setTitle:[NSString stringWithFormat:@"确定(%ld)",_tagArray.count] forState:UIControlStateNormal];
        [_pisHeaderView setOrangeButton];
    } else{
        [_pisHeaderView.submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_pisHeaderView setNormalButton];
    }
}

// 确定选择
- (void)submitClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (self.submitClickBlock != nil) {
            self.submitClickBlock(YES);
        }
    }];
}

- (void)returnSubmit:(SubmitClickBlock)block
{
    self.submitClickBlock = block;
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
