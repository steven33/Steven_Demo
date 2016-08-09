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
#import "UploadRequest.h"

#define BOUNDRY_B @"cc013nchft7" //分隔符标志
#define ENTER @"\r\n"  //回车换行

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
//    UIImage *image = [UIImage imageNamed:@"5.png"];
//    UIImage *image1 = [UIImage imageNamed:@"6.png"];
//    NSArray *arr = @[image,image1];
//    
//    [DataRequest UpImageWithURL:@"http://localhost:8080/Struts2-2/loginServlet" WithImageArr:arr HttpMethod:@"POST" SuccssfullBlock:^(id result) {
//        
//    } FailureBlock:^(id result) {
//        
//    }];
    

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
    
    [self blockUpload];
    
}

- (void)blockUpload
{
    UIButton * buton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    buton.backgroundColor = [UIColor redColor];
    [buton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];
}
-(void)click
{
    NSLog(@"click");
    [self uploadDataWithBlock];
    
    
}

-(void)uploadDataWithBlock
{
    //上传地址
    NSString * path = @"http://10.0.8.8/sns/my/upload_headimage.php";
    //转为URL
    NSURL * url = [NSURL URLWithString:path];
    //初始化请求
    NSMutableURLRequest * reuqest = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式
    [reuqest setHTTPMethod:@"POST"];
    
    //设置为multipart请求
    NSString * contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",BOUNDRY_B];
    [reuqest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    //初始化session的配置
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //初始化session
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
    
    //获取data
    NSData * data = [self getData];
    
    
    //设置为POST请求
    reuqest.HTTPMethod = @"POST";
    
    //初始化task,然后写好上传完成之后要做的事
    NSURLSessionUploadTask * task = [session uploadTaskWithRequest:reuqest fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"upload : %@",response);
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"upload : %@",dict);
        NSLog(@"upload : %@",[dict objectForKey:@"message"]);
    }];
    
    //启动上传
    [task resume];
    
}
-(NSData *)getData
{
    //创建可变data
    NSMutableData * data = [[NSMutableData alloc]init];
    
    //拼接第一个--boundry
    [data appendData:[[NSString stringWithFormat:@"--%@%@",BOUNDRY_B,ENTER] dataUsingEncoding:NSUTF8StringEncoding]];
    //第一个参数的描述部分
    [data appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"%@", @"headimage",@"10__7.jpg",ENTER] dataUsingEncoding:NSUTF8StringEncoding]];
    //第一个参数的类型,指定为jpeg,不然服务器不认识,注意后边多了一个换行
    [data appendData:[[NSString stringWithFormat:@"Content-Type: %@%@%@",@"image/jpeg",ENTER,ENTER] dataUsingEncoding:NSUTF8StringEncoding]];
    //这里直接拼接图片的数据
    UIImage * image = [UIImage imageNamed:@"10_7.jpg"];
    [data appendData:UIImageJPEGRepresentation(image, 1.0)];
    
    
    //后边的结尾
    [data appendData:[ [NSString stringWithFormat:@"%@--%@--%@",ENTER,BOUNDRY_B,ENTER] dataUsingEncoding:NSUTF8StringEncoding]];
    //返回数据
    return data;
    
    
}


@end
