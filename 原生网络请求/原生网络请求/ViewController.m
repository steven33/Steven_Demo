//
//  ViewController.m
//  原生网络请求
//
//  Created by qugo on 16/8/4.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "ViewController.h"
#import "DataRequest.h"
#import "DataRequest1.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    http://localhost:8080/Struts2-2/loginServlet?username=steven&password=sss
    
    
//    NSDictionary *params = @{@"username":@"password",
//                             @"password":@"password"};
//    [DataRequest RequestWithURL:@"http://localhost:8080/Struts2-2/loginServlet" Params:params HttpMethod:@"POST" SuccssfullBlock:^(id result) {
//        
//    } FailureBlock:^(id result) {
//        
//    }];
    UIImage *image = [UIImage imageNamed:@"5.png"];
    UIImage *image1 = [UIImage imageNamed:@"6.png"];
    NSArray *arr = @[image,image1];
    
    [DataRequest UpImageWithURL:@"http://localhost:8080/Struts2-2/loginServlet" WithImageArr:arr HttpMethod:@"POST" SuccssfullBlock:^(id result) {
        
    } FailureBlock:^(id result) {
        
    }];
    

    
    
    
    
    
    
//    dispatch_queue_t aQueue = dispatch_queue_create("ceshi", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(aQueue, ^{
//        for (int i = 0; i<100000; i++) {
//            NSLog(@"%d",i);
//        }
//    });
////
////    for (int i = 0; i<100000; i++) {
////        NSLog(@"主线程%d",i);
////    }
//    
////    dispatch_queue_t aQueue = dispatch_queue_create("ceshi", DISPATCH_QUEUE_SERIAL);
////    for (int i = 0; i<100000; i++) {
////        dispatch_async(aQueue, ^{
////            NSLog(@"%d",i);
////        });
////    }
//    
////    for (int i = 0; i<100000; i++) {
////        NSLog(@"主线程%d",i);
////    }
    
}

@end
