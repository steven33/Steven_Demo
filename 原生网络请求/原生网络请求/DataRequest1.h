//
//  DataRequest1.h
//  原生网络请求
//
//  Created by qugo on 16/8/4.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^CompletionLoadHandle)(id result);
@interface DataRequest1 : NSObject

+ (void)requestWithURL:(NSString *)urlstring
                params:(NSArray *)paramArr
          apiSecretKey:(NSString *)secretKey
            httpMethod:(NSString *)httpMethod
                 block:(CompletionLoadHandle)block;
+ (NSString *)encode:(NSString *)encodeStr;

@end
