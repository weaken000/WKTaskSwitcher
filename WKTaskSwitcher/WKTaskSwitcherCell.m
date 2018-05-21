//
//  CollectPageCell.m
//  WKWebView_demo
//
//  Created by mc on 2018/4/13.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import "WKTaskSwitcherCell.h"

@implementation WKTaskSwitcherCell {
    UIButton *_deleteButton;
    UIVisualEffectView *_visualView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupSubviews];
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8.0;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1.0;
        
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius  = 10;
        self.layer.shadowOffset  = CGSizeMake(0, -5);
    }
    return self;
}

- (void)setupSubviews {

    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualView = [[UIVisualEffectView alloc] initWithEffect:effect];
    
    _cellHeaderView = [[UIView alloc] init];
    [_cellHeaderView addSubview:_visualView];
    [self.contentView addSubview:_cellHeaderView];
    
    _deleteButton = [UIButton new];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_deleteButton setImage:[UIImage imageNamed:@"mutale_task_delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(click_deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_cellHeaderView addSubview:_deleteButton];
    
    _titleLab = [UILabel new];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font = [UIFont systemFontOfSize:13];
    [_cellHeaderView addSubview:_titleLab];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnW = 35;
    _titleLab.frame     = CGRectMake(10, 0, self.bounds.size.width - btnW - 10, btnW);
    _imageView.frame    = self.bounds;
    _cellHeaderView.frame = CGRectMake(0, 0, self.bounds.size.width, btnW);
    _visualView.frame   = _cellHeaderView.bounds;
    _deleteButton.frame = CGRectMake(self.bounds.size.width-btnW, 0, btnW, btnW);
}

- (void)setTaskInfo:(id<WKTaskModelProtocol>)taskInfo {
    _imageView.image = [taskInfo taskImage];
    _titleLab.text   = [taskInfo taskTitle];
}

- (void)click_deleteButton:(UIButton *)sender {
    if ([self.taskCellDelegate respondsToSelector:@selector(taskSwitcherCellDidClickDelete:)]) {
        [self.taskCellDelegate taskSwitcherCellDidClickDelete:self];
    }
}

@end
