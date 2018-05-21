//
//  ViewController.m
//  WKTaskSwitcherDemo
//
//  Created by mc on 2018/5/21.
//  Copyright © 2018年 weaken. All rights reserved.
//

#import "ViewController.h"

#import "WKTaskSwitcherViewController.h"

@interface TaskModel: NSObject<WKTaskModelProtocol>
@end

@implementation TaskModel

- (NSString *)taskTitle {
    return @"task";
}
- (UIImage *)taskImage {
    return nil;
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NSMutableArray<id<WKTaskModelProtocol>> *tasks = [NSMutableArray array];
    for (int i = 0; i < 15; i++) {
        TaskModel *t = [TaskModel new];
        [tasks addObject:t];
    }
    
    WKTaskSwitcherViewController *next = [WKTaskSwitcherViewController new];
    next.tasks = tasks;
    
    [self presentViewController:next animated:YES completion:nil];
}

@end
