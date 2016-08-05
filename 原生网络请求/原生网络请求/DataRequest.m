//
//  DataRequest.m
//  原生网络请求
//
//  Created by qugo on 16/8/4.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "DataRequest.h"

@implementation DataRequest

+ (void)RequestWithURL:(NSString *)url
                Params:(NSMutableDictionary *)params
            HttpMethod:(NSString *)httpMethod
       SuccssfullBlock:(SuccssfullBlock)succssfull
          FailureBlock:(FailureBlock)failure
{
    NSMutableString *url_String = [NSMutableString stringWithFormat:@"%@",url];
    //如果是GET请求(有参数把参数拼接到url中)
    if ([httpMethod isEqualToString:@"GET"] && params.count > 0) {
        [url_String appendString:@"?"];
        NSArray *allKeys = params.allKeys;
        for (int i = 0; i < allKeys.count; i++) {
            NSString *key = allKeys[i];
            NSString *value = params[key];
            value = [self encode:value];
                
            [url_String appendFormat:@"%@=%@",key,value];
            if (i<allKeys.count -1) {
                [url_String appendFormat:@"&"];
            }
        }
    }
    //创建request请求
//    NSDictionary *headerDic = @{@"accept":@"application/json",
//                                @"content-type":@"application/json"};
//    NSDictionary *headerDic = @{@"accept":@"application/json"};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url_String] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    if (!request) {
        failure(@"error_request_nil");
    }
    [request setHTTPMethod:httpMethod];
//    [request setAllHTTPHeaderFields:headerDic];
    
    //判断是否为POST请求，向请求体中添加参数
    if ([httpMethod isEqualToString:@"POST"]) {
        NSMutableString *paramStr = [NSMutableString string];
        NSArray *allKeys = params.allKeys;
        for (int i = 0; i < allKeys.count; i++) {
            NSString *key = allKeys[i];
            NSString *value = params[key];
            value = [self encode:value];
            
            [paramStr appendFormat:@"%@=%@",key,value];
            if (i<allKeys.count -1) {
                [paramStr appendFormat:@"&"];
            }
        }
        
        [request setHTTPBody:[paramStr dataUsingEncoding:NSUTF8StringEncoding]];
        
//        NSError *error = nil;
//        NSData *bodyJsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
//        [request setHTTPBody:bodyJsonData];
        
    
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure([NSString stringWithFormat:@"%@",error]);
            return ;
        }else{
            if ([response isKindOfClass:[NSURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSLog(@"%@",httpResponse);
            }
        }
        NSError *jsonError = nil;
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (jsonError) {
            NSLog(@"%@",[NSString stringWithFormat:@"%@",jsonDict]);
            failure([NSString stringWithFormat:@"%@",jsonDict]);
        }else{
            NSLog(@"%@",jsonDict);
            succssfull(jsonDict);
        }
    }];
    
    [dataTask resume];
}

//urlencode
+ (NSString *)encode:(NSString *)encodeStr
{
    NSString *encode = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                             NULL,
                                                                                             (CFStringRef)encodeStr,
                                                                                             NULL,
                                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                             kCFStringEncodingUTF8 ));
    return  encode;
}

#pragma mark - 上传图片
+ (void)UpImageWithURL:(NSString *)url
          WithImageArr:(NSMutableArray *)imageArr
            HttpMethod:(NSString *)httpMethod
       SuccssfullBlock:(SuccssfullBlock)succssfull
          FailureBlock:(FailureBlock)failure{
    //创建request请求
    NSDictionary *headerDic = @{@"accept":@"application/json",
                                @"content-type":@"image/jpeg"};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setAllHTTPHeaderFields:headerDic];
    [request setHTTPMethod:httpMethod];
    
    NSMutableData *bodyData = [NSMutableData data];
    for (UIImage *image in imageArr) {
        NSData * imageData = UIImageJPEGRepresentation(image,1.0);
        [bodyData appendData:imageData];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask * uploadtask = [session uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                failure([NSString stringWithFormat:@"%@",error]);
            }else{
                if ([response isKindOfClass:[NSURLResponse class]]) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    NSLog(@"%@",httpResponse);
                }
            }
            NSError *jsonError = nil;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if (jsonError) {
                NSLog(@"%@",jsonDict);
                failure([NSString stringWithFormat:@"%@",jsonDict]);
            }else{
                NSLog(@"%@",jsonDict);
                succssfull(jsonDict);
            }
        }];
    
    [uploadtask resume];
}

#pragma mark - 上传数据
+ (void)UpDataWithURL:(NSString *)url
          WithImageArr:(NSMutableArray *)imageArr
            HttpMethod:(NSString *)httpMethod
       SuccssfullBlock:(SuccssfullBlock)succssfull
          FailureBlock:(FailureBlock)failure{
    //创建request请求
    NSDictionary *headerDic = @{@"accept":@"application/json",
                                @"content-type":@"application/json"};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setAllHTTPHeaderFields:headerDic];
    [request setHTTPMethod:httpMethod];
    
    NSMutableData *bodyData = [NSMutableData data];
    for (UIImage *image in imageArr) {
        NSData * imageData = UIImageJPEGRepresentation(image,1.0);
        [bodyData appendData:imageData];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask * uploadtask = [session uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            failure([NSString stringWithFormat:@"%@",error]);
        }else{
            if ([response isKindOfClass:[NSURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSLog(@"%@",httpResponse);
            }
        }
        NSError *jsonError = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (jsonError) {
            
            failure([NSString stringWithFormat:@"%@",jsonDict]);
        }else{
            succssfull(jsonDict);
        }
    }];
    
    [uploadtask resume];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
//    self.progressview.progress = totalBytesSent/(float)totalBytesExpectedToSend;
}








@end
