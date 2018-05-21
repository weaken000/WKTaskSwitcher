//
//  WKFlowLayout.m
//  WKWebView_demo
//
//  Created by mc on 2018/4/11.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import "WKTaskSwitcherFlowLayout.h"

@interface WKTaskSwitcherFlowLayout()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
//屏幕同时显示的cell数量，topVisiable+bottomVisiable+1
@property (nonatomic, assign) NSInteger visiableCount;

@end

@implementation WKTaskSwitcherFlowLayout {
    CGFloat _totalH;
    
    CGFloat _itemHeight;//可见标准高度
    CGFloat _topMargin;//顶部距离高度
    CGFloat _bottomMargin;//底部距离高度
    CGFloat _maxScale;//最大比例
    CGFloat _minScale;//最小比例
    
    UIPanGestureRecognizer *_panGesure;
}

- (instancetype)init {
    if (self == [super init]) {
        _deleteOptical = 0.65;
        _topVisiableCount = 3;
        _bottomVisiableCount = 2;
        _visiableCount = _topVisiableCount + _bottomVisiableCount + 1;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self updateAttbuteArrayByScrolling];
    }
}


#pragma mark - override
- (void)prepareLayout {
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    if (CGSizeEqualToSize(self.itemSize, CGSizeMake(50, 50))) {
        CGFloat itemW = (self.collectionView.bounds.size.width - 20.0) * 0.90;
        CGFloat itemH = itemW / 0.7;
        self.itemSize = CGSizeMake(itemW, itemH);
        _maxScale = (self.collectionView.bounds.size.width - 20.0) / itemW;
        _minScale = 0.90;
    }
    
    if (!_panGesure && self.collectionView) {
        _panGesure = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(deleteGesture:)];
        _panGesure.delegate = self;
        _panGesure.maximumNumberOfTouches = 1;
        _panGesure.delaysTouchesBegan = YES;
        [self.collectionView addGestureRecognizer:_panGesure];
    }
}

- (CGSize)collectionViewContentSize {
    CGFloat needHeight = self.itemSize.height + _topMargin + _bottomMargin + (self.attributesArray.count - 1) * _itemHeight + 1;
    return CGSizeMake(0, needHeight);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray *tmp = [NSArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    if (CGSizeEqualToSize(self.itemSize, CGSizeZero) || CGRectEqualToRect(CGRectZero, self.collectionView.bounds)) {
        return tmp;
    }

    if (!_attributesArray.count) {
        [self setupAttributeArray];
        return _attributesArray;
    }
    
    return _attributesArray;
}

#pragma mark - private
//初始化所有描述信息
- (void)setupAttributeArray {
    
    _attributesArray = [NSMutableArray array];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    //获取所有cell描述
    CGRect contentRect =
    CGRectMake(0, 0, self.collectionView.bounds.size.width, self.itemSize.height * itemCount);
    NSArray *tmp = [super layoutAttributesForElementsInRect:contentRect];
    [_attributesArray addObjectsFromArray:[[NSArray alloc] initWithArray:tmp copyItems:YES]];
    
    _topMargin = (self.collectionView.bounds.size.height - self.itemSize.height) / 2.0;
    _bottomMargin = _topMargin;
    
    _itemHeight = CGRectGetHeight(self.collectionView.frame) / _visiableCount;
    _totalH     = [self collectionViewContentSize].height;
    
    CGPoint needOffset = CGPointMake(0, _totalH - CGRectGetHeight(self.collectionView.frame));
    self.collectionView.contentOffset = needOffset;

    CGFloat centerX = self.collectionView.bounds.size.width / 2;
    CGFloat firstCenterY = _topMargin + self.itemSize.height * 0.5;
    CGFloat centerY = needOffset.y + self.collectionView.bounds.size.height / 2;
    
    for (int i = 0; i < _attributesArray.count; i++) {
        UICollectionViewLayoutAttributes *att = [_attributesArray objectAtIndex:i];
        
        att.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        att.center = CGPointMake(centerX, firstCenterY);
        firstCenterY += _itemHeight;
        CGFloat progress = (att.center.y - centerY) / CGRectGetHeight(self.collectionView.frame) * self.visiableCount;
        [self transformFor:att byProgress:progress];
    }
}



//更新描述信息
- (void)updateAttbuteArrayByScrolling {

    if (!self.attributesArray.count) return;
    
    CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.bounds.size.height / 2;
//
//    //获取当前中心点的att
//    NSInteger targetIndex = (centerY - _topMargin) / _itemHeight;
//    targetIndex = MIN(self.attributesArray.count - 1, targetIndex);
//    NSInteger end;
//    NSInteger start;
//
//    if (self.attributesArray.count <= self.visiableCount) {
//        start = 0;
//        end = self.attributesArray.count - 1;
//    }
//    else {
//        end = MIN(self.attributesArray.count - 1, targetIndex + self.bottomVisiableCount + 1);
//        start = MAX(0, targetIndex - self.topVisiableCount - 1);
//    }

    for (NSInteger i = 0; i < self.attributesArray.count; i++) {
        UICollectionViewLayoutAttributes *att = [_attributesArray objectAtIndex:i];
        CGFloat progress = (att.center.y - centerY) / CGRectGetHeight(self.collectionView.frame) * self.visiableCount;
        [self transformFor:att byProgress:progress];
    }
    
    [self invalidateLayout];
}


- (void)transformFor:(UICollectionViewLayoutAttributes *)attribute byProgress:(CGFloat)progress {
    
    if (progress < -3) {
        attribute.alpha = 0.0;
        return;
    }
    
    if (progress == 0) {
        attribute.alpha = 1.0;
        attribute.transform = CGAffineTransformIdentity;
        return;
    }
    
    if (progress >= -2.7) {
        attribute.alpha = 1.0;
    }
    else {
        attribute.alpha = 0.3;
    }
    
    if (progress < 0) {//顶点为(-_topVisiableCount, _topMargin)的过原点二次函数
        //比例
        CGFloat scale = ((1 - _minScale) / (_topVisiableCount * _topVisiableCount)) * (progress + _topVisiableCount) * (progress + _topVisiableCount) + _minScale;
        
        CGFloat a = - _topMargin / (_topVisiableCount * _topVisiableCount);
        CGFloat addY = a * (progress + _topVisiableCount) * (progress + _topVisiableCount) + _topMargin;
        CGFloat offsetY = fabs(progress) * _itemHeight - addY - (self.itemSize.height * (1 - scale) / 2.0);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, 0, offsetY);
        transform = CGAffineTransformScale(transform, scale, scale);
        attribute.transform = transform;
    }
    else {//过(_bottomVisiableCount, _bottomMargin)和原点二次函数
        
        CGFloat scale = ((1 - _maxScale) / _bottomVisiableCount / _bottomVisiableCount) * (progress - _bottomVisiableCount) * (progress - _bottomVisiableCount) + _maxScale;
        
        float aOptical = 2;//二次函数的二次系数A
        float bOptical = (_bottomMargin - aOptical * _bottomVisiableCount * _bottomMargin) / _bottomMargin;
        
        CGFloat addY = aOptical * progress * progress + bOptical * progress;
        CGFloat offsetY = fabs(progress) * _itemHeight + addY + (self.itemSize.height * (1 - scale) / 2.0);
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, 0, offsetY);
        transform = CGAffineTransformScale(transform, scale, scale);
        attribute.transform = transform;
    }
}

#pragma mark - Action
- (void)deleteGesture:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:
        {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_selectIndexPath];
            CGPoint center = cell.center;
            CGPoint point = [gesture translationInView:gesture.view];
            center.x = CGRectGetMidX(self.collectionView.bounds) + point.x;
            CGFloat pix = - 1 / CGRectGetWidth(self.collectionView.bounds);
            CGFloat alpha = fabs(point.x) * pix + 1;
            cell.center = center;
            cell.alpha = alpha;
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint point = [gesture translationInView:gesture.view];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_selectIndexPath];
            if (fabs(cell.center.x - CGRectGetMidX(self.collectionView.bounds)) > CGRectGetWidth(self.collectionView.bounds) * self.deleteOptical && self.deleteBlock) {//删除
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint center = cell.center;
                    if (point.x > 0) {//向右
                        center.x = CGRectGetMidX(self.collectionView.bounds) + CGRectGetWidth(self.collectionView.bounds);
                        cell.center = center;
                    }
                    else {//向左
                        center.x = - CGRectGetMidX(self.collectionView.bounds) - CGRectGetWidth(self.collectionView.bounds);
                        cell.center = center;
                    }
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    CGFloat oldOffsetY = self.collectionView.contentOffset.y;
                    
                    NSArray *tmp = [self.attributesArray copy];
                    NSInteger target = -1;
                    for (int i = 0; i < tmp.count; i++) {
                        UICollectionViewLayoutAttributes *att = [tmp objectAtIndex:i];
                        if (att.indexPath.item == self.selectIndexPath.item) {
                            [self.attributesArray removeObjectAtIndex:i];
                            target = i;
                            break;
                        }
                    }
                    
                    //更新删除后的描述信息
                    if (target >= 0 && target < tmp.count-1) {//删除最后一位置时不需要更新位置
                        CGFloat firstCenterY = self->_topMargin + self.itemSize.height * 0.5;
                        CGFloat centerX = self.collectionView.bounds.size.width / 2;
                        for (NSInteger i = target; i < self.attributesArray.count; i++) {
                            UICollectionViewLayoutAttributes *att = [self.attributesArray objectAtIndex:i];
                            att.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                            att.center = CGPointMake(centerX, firstCenterY + (i * self->_itemHeight));
                        }
                    }
                    
                    CGFloat offsetY = oldOffsetY - self->_itemHeight;
                    [self.collectionView setContentOffset:CGPointMake(0, MAX(0, offsetY)) animated:YES];

                    if (target >= 0) {//更新数据源
                        self.deleteBlock(self->_selectIndexPath);
                    }
                    self->_selectIndexPath = nil;
                }];
            }
            else {//回滚
                [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGPoint center = cell.center;
                    center.x = CGRectGetMidX(self.collectionView.bounds);
                    cell.center = center;
                    cell.alpha = 1.0;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - public
- (void)deleteCollectionViewLayoutAttributeAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < 0 || indexPath.item > _attributesArray.count - 1 || !self.deleteBlock) return;
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) return;
    
    CGPoint center = cell.center;
    center.x = - CGRectGetMidX(self.collectionView.bounds) - CGRectGetWidth(self.collectionView.bounds);
    
    [UIView animateWithDuration:0.4 animations:^{
        cell.center = center;
        cell.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [self.attributesArray removeObjectAtIndex:indexPath.item];
        //更新删除后的描述信息
        if (indexPath.item < self.attributesArray.count) {//删除最后一位置时不需要更新位置
            CGFloat firstCenterY = self->_topMargin + self.itemSize.height * 0.5;
            CGFloat centerX = self.collectionView.bounds.size.width / 2;
            
            for (NSInteger i = indexPath.item; i < self.attributesArray.count; i++) {
                UICollectionViewLayoutAttributes *att = [self.attributesArray objectAtIndex:i];
                att.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                att.center = CGPointMake(centerX, firstCenterY + (i * self->_itemHeight));
            }
            
        }
        
        CGFloat offsetY = self.collectionView.contentOffset.y - self->_itemHeight;
        [self.collectionView setContentOffset:CGPointMake(0, MAX(0, offsetY)) animated:YES];
        
        self.deleteBlock(indexPath);
    }];
    
}

- (void)scrollToBottomBehind:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *rawCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:2.0 animations:^{
        CGFloat offsetY = 0;
        for (NSInteger i = indexPath.item + 1; i < self.attributesArray.count; i++) {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            if (i == indexPath.item + 1) {
                offsetY = cell.frame.origin.y - CGRectGetMaxY(rawCell.frame);
            }
            CGFloat y = cell.center.y;
            y -= offsetY;
            cell.center = CGPointMake(cell.center.x, y);
        }
    }];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint t = [pan translationInView:pan.view];
    if (fabs(t.y) > fabs(t.x) * 0.3) {
        return NO;
    }
    
    NSInteger i = _attributesArray.count - 1;
    while (i >= 0) {
        UICollectionViewLayoutAttributes *att = [_attributesArray objectAtIndex:i];
        if (CGRectContainsPoint(att.frame, [gestureRecognizer locationInView:gestureRecognizer.view])) {
            _selectIndexPath = att.indexPath;
            return YES;
        }
        i--;
    }
    return NO;
}

#pragma mark - setter
- (void)setVisiableCount:(NSInteger)visiableCount {

    if (visiableCount == 0) return;
    
    if (_visiableCount != visiableCount) {
        [_attributesArray removeAllObjects];
        _attributesArray = nil;
        [self.collectionView reloadData];
    }
    _visiableCount = visiableCount;
}


@end
