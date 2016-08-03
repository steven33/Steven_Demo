//
//  ViewController.m
//  单例
//
//  Created by qugo on 16/5/4.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import "ViewController.h"
#import "MyManager.h"
#import "OneViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    MyManager *manager1 = [MyManager check];
    if (!manager1) {
        manager1 = [MyManager sharedManager];
    }
    manager1.name = @"steven";
    manager1.age = @34;
    manager1.school = @"nihao shijie";
    manager1.dic = @{@"name":@"hahah"};
    [manager1 save];
    NSLog(@"%@",manager1);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 80, 50)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
  
}

- (void)pushAction
{
    [self presentViewController:[[OneViewController alloc] init] animated:YES completion:^{
        
    }];
}



@end
