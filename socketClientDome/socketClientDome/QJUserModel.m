//
//  QJUserModel.m
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import "QJUserModel.h"

@implementation QJUserModel

+(instancetype)userModelWithName:(NSString *)userName
{
    QJUserModel * userModel = [[self alloc] init];
    
    userModel.userName = userName ;
    userModel.userId = [NSString stringWithFormat:@"%d",arc4random_uniform(5000)+arc4random_uniform(500)];
    
    return userModel ;
}

@end
