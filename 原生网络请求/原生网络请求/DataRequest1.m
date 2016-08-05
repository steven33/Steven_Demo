//
//  DataRequest1.m
//  原生网络请求
//
//  Created by qugo on 16/8/4.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "DataRequest1.h"

@implementation DataRequest1
+ (void)requestWithURL:(NSString *)urlstring
                params:(NSArray *)paramArr
          apiSecretKey:(NSString *)secretKey
            httpMethod:(NSString *)httpMethod
                 block:(CompletionLoadHandle)block
{
    paramArr = [paramArr sortedArrayUsingSelector:@selector(compare:)];
    NSString *paramStr=[paramArr componentsJoinedByString:@"&"];
    NSString *signature_data = [self encode:paramStr];
    NSString *requestStr = [NSString stringWithFormat:@"%@&signature=%@",paramStr,signature_data];
    NSString *urlStr = urlstring;
    NSURL *url;
    if ([httpMethod isEqualToString:@"POST"]) {
        
        url = [NSURL URLWithString:urlStr];
    }else if ([httpMethod isEqualToString:@"GET"]){
        url = [NSURL URLWithString:[urlStr stringByAppendingFormat:@"&%@",requestStr]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:httpMethod];
    if ([httpMethod isEqualToString:@"POST"]) {
        
        NSData *data = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%@,  %@",response.URL,response.URL.scheme);
        NSDictionary *dict = nil;
        if (data) {
            dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:Nil];
        }
        if (block) {
            block(dict);
        }
    }];
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


@end
