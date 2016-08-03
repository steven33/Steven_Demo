//
//  MyManager.m
//  单例
//
//  Created by qugo on 16/5/4.
//  Copyright © 2016年 qugo. All rights reserved.
//

#import "MyManager.h"

@implementation MyManager

+(id)sharedManager{
    static MyManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil) {
            sharedMyManager = [[MyManager alloc] init];
        }
    }
    return sharedMyManager;
}

//+(id)sharedManager{
//    static MyManager *sharedMyManager = nil;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        sharedMyManager = [[self alloc] init];
//        
//    });
//    return sharedMyManager;
//}

#pragma-- mark 归档
- (void)encodeWithCoder:(NSCoder *)aCoder;{
    // 这里放置需要持久化的属性
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.school forKey:@"school"];
    [aCoder encodeObject:self.dic forKey:@"dic"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [self init])
    {
        //  这里务必和encodeWithCoder方法里面的内容一致，不然会读不到数据
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.school = [aDecoder decodeObjectForKey:@"school"];
        self.dic = [aDecoder decodeObjectForKey:@"dic"];
    }
    return self;
}
+ (NSString *)fileName{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:NSStringFromClass(self)];
    
    return filename;
}

- (BOOL)save
{
    return [NSKeyedArchiver archiveRootObject:self toFile:MyManager.fileName];
}
+ (id)check
{
    MyManager *mark = [NSKeyedUnarchiver unarchiveObjectWithFile:MyManager.fileName];
    return mark;
}
@end
