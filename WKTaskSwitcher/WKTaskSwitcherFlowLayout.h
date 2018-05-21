//
//  WKFlowLayout.h
//  WKWebView_demo
//
//  Created by mc on 2018/4/11.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKTaskSwitcherFlowLayout : UICollectionViewFlowLayout
//在中心基准线以上可以个数，默认3个
@property (nonatomic, assign) NSInteger topVisiableCount;
//在中心基准线以下可以个数，默认2个
@property (nonatomic, assign) NSInteger bottomVisiableCount;
//左右滑动删除时的触发比例，默认0.65
@property (nonatomic, assign) CGFloat deleteOptical;
//删除动作触发调用block
@property (nonatomic, copy  ) void (^ deleteBlock)(NSIndexPath *);

- (void)scrollToBottomBehind:(NSIndexPath *)indexPath;

- (void)deleteCollectionViewLayoutAttributeAtIndexPath:(NSIndexPath *)indexPath;


@end
