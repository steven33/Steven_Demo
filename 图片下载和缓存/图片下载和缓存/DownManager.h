//
//  DownRequest.h
//  图片下载和缓存
//
//  Created by qugo on 16/8/10.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ProgressVulueBlock)(float gress);
typedef void(^ErrorTypeStrBlock)(NSString *errorTypeStr);
typedef void(^ImageBlock)(UIImage *image);

@interface DownManager : NSObject

@property (nonatomic,copy)ProgressVulueBlock gressVulue;
@property (nonatomic,copy)ErrorTypeStrBlock  errorTypeStr;
@property (nonatomic,copy)ImageBlock  imageBlock;

+ (id)SharedManager;

- (void)downLoadImageWithURLStr:(NSString *)urlStr
                  ProgressVulue:(ProgressVulueBlock)gressVulue
                   ErrorTypeStr:(ErrorTypeStrBlock)errorTypeStr
                     ImageBlock:(ImageBlock)imageBlock;


- (void)resume;
- (void)pause;
- (void)cancel;

@end
