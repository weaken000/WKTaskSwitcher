//
//  WKTaskSwitcherViewController.m
//  JanesiBrowser
//
//  Created by mc on 2018/5/21.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import "WKTaskSwitcherViewController.h"

@interface WKTaskSwitcherViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, WKTaskSwitcherCellDelegate>

@end

@implementation WKTaskSwitcherViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0];
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutSubview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.collectionView removeObserver:self.customFlowLayout forKeyPath:@"contentOffset"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - setup
- (void)setupSubviews {
    
    _customFlowLayout = [WKTaskSwitcherFlowLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_customFlowLayout];
    _collectionView.backgroundColor = self.view.backgroundColor;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[WKTaskSwitcherCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    [self.collectionView addObserver:self.customFlowLayout forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _bottomView = [UIView new];
    _bottomView.alpha = 0.8;
    [_bottomView addSubview:effectView];
    [self.view addSubview:_bottomView];
    
    _addButton = [UIButton new];
    _addButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_addButton setImage:[UIImage imageNamed:@"mutable_task_add"] forState:UIControlStateNormal];
    [_addButton
     addTarget:self
     action:@selector(click_addButton:)
     forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_addButton];
    
    _backButton = [UIButton new];
    _backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_backButton setImage:[UIImage imageNamed:@"mutable_task_back"] forState:UIControlStateNormal];
    [_backButton
     addTarget:self
     action:@selector(click_backButton:)
     forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_backButton];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)layoutSubview {
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets edge = self.view.safeAreaInsets;
        _bottomView.frame = CGRectMake(edge.left, self.view.bounds.size.height-50-edge.bottom, self.view.bounds.size.width, 50 + edge.bottom);
        _collectionView.frame = CGRectMake(edge.left, edge.top+10, self.view.bounds.size.width, self.view.bounds.size.height-edge.bottom-edge.top-10);
    }
    else {
        _bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50);
        _collectionView.frame = CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.height-10);
    }
    
    CGFloat margin = 80;
    CGFloat itemW = (CGRectGetWidth(_bottomView.frame) - 2 * margin) / 2.0;
    CGFloat itemH = 50;
    
    _bottomView.subviews.firstObject.frame = _bottomView.bounds;
    _addButton.frame = CGRectMake(margin, 0, itemW, itemH);
    _backButton.frame = CGRectMake(margin+itemW, 0, itemW, itemH);
    
}

#pragma mark - Action
- (void)click_addButton:(UIButton *)sender {

}

- (void)click_backButton:(UIButton *)sender {
    
}

#pragma mark - WKTaskSwitcherCellDelegate
- (void)taskSwitcherCellDidClickDelete:(WKTaskSwitcherCell *)cell {
    [self.customFlowLayout deleteCollectionViewLayoutAttributeAtIndexPath:[self.collectionView indexPathForCell:cell]];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WKTaskSwitcherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.taskCellDelegate = self;
    cell.taskInfo = self.tasks[indexPath.item];
    cell.layer.zPosition = indexPath.row * 2;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
