//
//  SetDetailModel.h
//  QuGou
//  搭配数据
//
//  Created by wwq on 15-08-01.
//  Copyright (c) 2015年 北京趣购网络技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetDetailModel : NSObject

@property (nonatomic,copy) NSString *set_id;
@property (nonatomic,copy) NSString *set_image;
@property (nonatomic,copy) NSString *set_isLike;
@property (nonatomic,copy) NSString *set_name;
@property (nonatomic,copy) NSString *set_imageHeight;
@property (nonatomic,copy) NSString *set_imageWidth;

@property (nonatomic,copy) NSString *set_description;
@property (nonatomic,copy) NSString *set_shortDescription;

@property (nonatomic,strong) NSMutableDictionary *set_review;//评论
@property (nonatomic,copy) NSString *set_likeCount;//收藏量

@property (nonatomic,strong) NSMutableArray *set_extraImages;


/////////////
- (id)initWithModel:(id)sourceModel;


@end
