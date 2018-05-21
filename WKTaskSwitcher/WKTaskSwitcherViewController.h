//
//  WKTaskSwitcherViewController.h
//  JanesiBrowser
//
//  Created by mc on 2018/5/21.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKTaskSwitcherFlowLayout.h"
#import "WKTaskSwitcherCell.h"

@class WKTaskSwitcherViewController;

@protocol WKTaskModelProtocol <NSObject>
@required
- (UIImage *)taskImage;
- (NSString *)taskTitle;
@end

@protocol WKTaskSwitcherViewControllerDelegate <NSObject>
@optional
- (void)taskController:(WKTaskSwitcherViewController *)taskController didDeleteTask:(id<WKTaskModelProtocol>)task;
- (void)taskController:(WKTaskSwitcherViewController *)taskController didShowTask:(id<WKTaskModelProtocol>)task;
- (id<WKTaskModelProtocol>)taskControllerDidAddTask:(WKTaskSwitcherViewController *)taskController;
@end

@interface WKTaskSwitcherViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<id<WKTaskModelProtocol>> *tasks;

@property (nonatomic, weak  ) id<WKTaskSwitcherViewControllerDelegate> taskSwitcherDelegate;

@property (nonatomic, strong) UIView   *bottomView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) WKTaskSwitcherFlowLayout *customFlowLayout;

- (void)click_addButton:(UIButton *)sender;

- (void)click_backButton:(UIButton *)sender;

@end
