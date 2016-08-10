
//
//  DownRequest.m
//  图片下载和缓存
//
//  Created by qugo on 16/8/10.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "DownManager.h"

#define CACHEPATHFORURLSTRING(urlStr)  [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"stevenCache"] stringByAppendingPathComponent:[urlStr lastPathComponent]]

@interface DownManager()<NSURLSessionDelegate>

@property (strong,nonatomic)NSURLSession * session;
@property (strong,nonatomic)NSURLSessionDataTask * dataTask;
@property (nonatomic)long long expectlength;
@property (strong,nonatomic) NSMutableData * buffer;
@property (strong,nonatomic)NSString *imageUrl;

@end

@implementation DownManager

+ (id)SharedManager{
    static DownManager *sharedDownManager = nil;
    @synchronized(self) {
        if (!sharedDownManager) {
            sharedDownManager = [[DownManager alloc] init];
            [DownManager initialize];
        }
    }
    return sharedDownManager;
}
- (void)downLoadImageWithURLStr:(NSString *)urlStr
                  ProgressVulue:(ProgressVulueBlock)gressVulue
                   ErrorTypeStr:(ErrorTypeStrBlock)errorTypeStr
                     ImageBlock:(ImageBlock)imageBlock
{
    if (gressVulue) {
        self.gressVulue = gressVulue;
    }
    if (errorTypeStr) {
        self.errorTypeStr = errorTypeStr;
    }
    if (imageBlock) {
        self.imageBlock = imageBlock;
    }
    self.imageUrl = urlStr;
    self.dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:self.imageUrl]];
    
    UIImage *image;
    NSData *data = [NSData dataWithContentsOfFile:CACHEPATHFORURLSTRING(self.imageUrl)];
    if (data) {
        image = [UIImage imageWithData:data];
    }
    if (!image) {
        [self resume];
    }else{
        if (imageBlock) {
            imageBlock(image);
            NSLog(@"----------已经下载过了");
            return;
        }
    }
}

#pragma mark -操作方法
- (void)resume{
    if (self.dataTask.state == NSURLSessionTaskStateSuspended) {
        [self.dataTask resume];
    }
}
- (void)pause{
    if (self.dataTask.state == NSURLSessionTaskStateRunning) {
        [self.dataTask suspend];
    }
}
- (void)cancel{
    switch (self.dataTask.state) {
        case NSURLSessionTaskStateRunning:
        case NSURLSessionTaskStateSuspended:
            [self.dataTask cancel];
            break;
        default:
            break;
    }
}

//属性全部采用惰性初始化
#pragma mark - lazy property
-(NSMutableData *)buffer{
    if (!_buffer) {
        _buffer = [[NSMutableData alloc] init];
    }
    return _buffer;
}
- (NSURLSession *)session{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
#pragma mark -  URLSession delegate method
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    long long  length = [response expectedContentLength];
    if (length != -1) {
        //存储一共要传输的数据长度
        self.expectlength = [response expectedContentLength];
        //继续数据传输
        completionHandler(NSURLSessionResponseAllow);
    }else{
        //如果Response里不包括数据长度的信息，就取消数据传输
        completionHandler(NSURLSessionResponseCancel);
    }
    
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.buffer appendData:data];//数据放到缓冲区里
    float progressValue = [self.buffer length]/((float) self.expectlength);
    if (self.gressVulue) {
        self.gressVulue(progressValue);
    }
   
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [self.session finishTasksAndInvalidate];//完成task就invalidate
    
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //用GCD的方式，保证在主线程上更新UI
            UIImage * image = [UIImage imageWithData:self.buffer];
            if (self.imageBlock) {
                self.imageBlock(image);
            }
            //写入缓存
            [self.buffer writeToFile:CACHEPATHFORURLSTRING(self.imageUrl) atomically:YES];
            self.session = nil;
            self.dataTask = nil;
        });
    }else{
        NSDictionary * userinfo = [error userInfo];
        NSString * failurl = [userinfo objectForKey:NSURLErrorFailingURLStringErrorKey];
        NSString * localDescription = [userinfo objectForKey:NSLocalizedDescriptionKey];
        if ([failurl isEqualToString:self.imageUrl] && [localDescription isEqualToString:@"cancelled"]) {
            //如果是task被取消了
        }else{
            //其他错误
            self.buffer = nil;
        }
        if (self.errorTypeStr) {
            self.errorTypeStr(failurl);
        }
        
    }
}

#pragma mark-缓存相关
#pragma mark 清除沙盒中的图片缓存
- (void)clearDiskCache {
    NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"stevenCache"];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cache error:NULL];
    for (NSString *fileName in contents) {
        [[NSFileManager defaultManager] removeItemAtPath:[cache stringByAppendingPathComponent:fileName] error:nil];
    }
}
//创建用来缓存图片的文件夹
+ (void)initialize {
    NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"stevenCache"];
    BOOL isDir = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:cache isDirectory:&isDir];
    if (!isExists || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache withIntermediateDirectories:YES attributes:nil error:nil];
    }
}



@end
