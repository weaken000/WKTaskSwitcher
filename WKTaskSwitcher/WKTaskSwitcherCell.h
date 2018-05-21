//
//  CollectPageCell.h
//  WKWebView_demo
//
//  Created by mc on 2018/4/13.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKTaskSwitcherViewController.h"

@class WKTaskSwitcherCell;
@protocol WKTaskSwitcherCellDelegate <NSObject>
- (void)taskSwitcherCellDidClickDelete:(WKTaskSwitcherCell *)cell;
@end

@interface WKTaskSwitcherCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *cellHeaderView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) id taskInfo;

@property (nonatomic, weak  ) id<WKTaskSwitcherCellDelegate> taskCellDelegate;

@end
