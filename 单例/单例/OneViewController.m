//
//  OneViewController.m
//  单例
//
//  Created by qugo on 16/5/4.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import "OneViewController.h"
#import "MyManager.h"
#define dddd 12.0

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyManager *manager1 = [MyManager check];
    if (!manager1) {
        manager1 = [MyManager sharedManager];
    }
    manager1.name = @"steven2";
    manager1.age = @1114;
    manager1.school = @"你好";
    manager1.dic = @{@"name":@"会到货附近的"};
    [manager1 save];
    NSLog(@"%@",manager1);
    
    
    
}

@end
