//
//  MyManager.h
//  单例
//
//  Created by qugo on 16/5/4.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManager : NSObject

@property (nonatomic,copy)NSString       *name;
@property (nonatomic,assign)NSNumber    *age;
@property (nonatomic,copy)NSString       *school;
@property (nonatomic,strong)NSDictionary *dic;

+(id)sharedManager;
- (BOOL)save;
+ (id)check;
+ (NSString *)fileName;

@end
