//
//  QJMessagesViewController.h
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@class QJUserModel ;

@interface QJMessagesViewController : JSQMessagesViewController

@property (nonatomic , strong)QJUserModel * userModel ;

@end
