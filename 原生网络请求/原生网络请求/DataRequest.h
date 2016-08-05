//
//  DataRequest.h
//  原生网络请求
//
//  Created by qugo on 16/8/4.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SuccssfullBlock)(id result);
typedef void(^FailureBlock)(id result);

@interface DataRequest : NSObject
+ (void)RequestWithURL:(NSString *)url
                Params:(NSMutableDictionary *)params
            HttpMethod:(NSString *)httpMethod
       SuccssfullBlock:(SuccssfullBlock)succssfull
          FailureBlock:(FailureBlock)failure;

+ (void)UpImageWithURL:(NSString *)url
          WithImageArr:(NSMutableArray *)imageArr
            HttpMethod:(NSString *)httpMethod
       SuccssfullBlock:(SuccssfullBlock)succssfull
          FailureBlock:(FailureBlock)failure;
+ (void)UpDataWithURL:(NSString *)url
          WithImageArr:(NSMutableArray *)imageArr
            HttpMethod:(NSString *)httpMethod
       SuccssfullBlock:(SuccssfullBlock)succssfull
          FailureBlock:(FailureBlock)failure;


@end
