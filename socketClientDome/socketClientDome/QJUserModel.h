//
//  QJUserModel.h
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJUserModel : NSObject

@property (nonatomic , copy) NSString * userName ;

@property (nonatomic , copy) NSString * userId ;

@property (nonatomic , copy) NSString * roomName ;

+(instancetype)userModelWithName:(NSString *)userName roomName:(NSString *)roomName;

@end
