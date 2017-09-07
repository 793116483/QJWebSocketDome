//
//  QJMessagesViewController.h
//  socketClientDome
//
//  Created by 瞿杰 on 2017/9/7.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>

@class QJUserModel , QJMessagesViewController;

@protocol QJMessagesViewControllerDelegate <NSObject>

@required
-(void)messagesVc:(QJMessagesViewController *)msgVc didChatCompleteData:(NSArray<NSDictionary *> *)chatDataArray ;

@end

@interface QJMessagesViewController : JSQMessagesViewController

@property(nonatomic , weak) id<QJMessagesViewControllerDelegate> delegate ;

+(instancetype)messagesViewControllerWithUserModel:(QJUserModel *)userModel chatDataArray:(NSArray<NSDictionary *> *)chatDataArray ;



@end
