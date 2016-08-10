//
//  ViewController.m
//  图片下载和缓存
//
//  Created by qugo on 16/8/9.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "ViewController.h"
#import "DownManager.h"

@interface ViewController ()

@property (strong,nonatomic)DownManager * downManager;


@property (nonatomic,strong)UIButton *resumeButton;
@property (nonatomic,strong)UIButton *pauseButton;
@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIProgressView *progressview;
@property (nonatomic,strong)UIImageView * imageview;

@end

static NSString * imageURL = @"http://f12.topit.me/o129/10129120625790e866.jpg";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    self.progressview = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 120, 300, 5)];
    self.progressview.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.progressview];
    
    self.resumeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 60, 30)];
    self.resumeButton.backgroundColor = [UIColor redColor];
    [self.resumeButton setTitle:@"下载" forState:UIControlStateNormal];
    [self.resumeButton addTarget:self action:@selector(resume:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resumeButton];
    
    self.pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 60, 60, 30)];
    self.pauseButton.backgroundColor = [UIColor redColor];
    [self.pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    [self.pauseButton addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseButton];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 60, 60, 30)];
    self.cancelButton.backgroundColor = [UIColor redColor];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, 300, 200)];
    [self.view addSubview:self.imageview];
   NSArray *dataArr = @[@"http://img2.3lian.com/2014/f3/53/d/101.jpg",
                @"http://img2.3lian.com/2014/f3/53/d/102.jpg",
                @"http://img2.3lian.com/2014/f3/53/d/103.jpg",
                @"http://img2.3lian.com/2014/f3/53/d/104.jpg",
                @"http://img2.3lian.com/2014/f3/53/d/105.jpg",
                @"http://img2.3lian.com/2014/f3/53/d/106.jpg",
                @"http://img2.3lian.com/2014/f3/53/d/107.jpg",
                @"http://img2.3lian.com/2014/f3/53/d/108.jpg",
                @"http://img2.3lian.com/2014/f3/53/d/109.jpg",
                ];
    
    self.downManager = [DownManager SharedManager];
    [self.downManager downLoadImageWithURLStr:dataArr[1] ProgressVulue:^(float gress) {
//        NSLog(@"gress__=== :%f",gress);
        self.progressview.progress =gress;
    } ErrorTypeStr:^(NSString *errorTypeStr) {
        NSLog(@"errorTypeStr :%@",errorTypeStr);
    }ImageBlock:^(UIImage *image) {
        self.imageview.image = image;
    }];
    
   
    
    
}
#pragma mark - target-action
- (void)resume:(id)sender {
    [self.downManager resume];
}
//注意判断当前Task的状态
- (void)pause:(UIButton *)sender {
   [self.downManager pause];
}

- (void)cancel:(id)sender {
    [self.downManager cancel];
}


@end
