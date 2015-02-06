//
//  SNSLoginViewController.h
//  tuangouproject
//
//  Created by  na on .
//
//

#import "WebViewController.h"

enum SNSLoginType {
    SNSLoginTypeWeibo,
    SNSLoginTypeQQ
};

@protocol SNSLoginViewControllerDelegate;

@interface SNSLoginViewController : WebViewController
@property (nonatomic) enum SNSLoginType type;
@property (nonatomic) id <SNSLoginViewControllerDelegate> delegate;

+ (id)weiboLoginViewController;
+ (id)qqLoginViewController;
@end

@protocol SNSLoginViewControllerDelegate  <NSObject>
- (void)snsLoginViewControllerFinished:(SNSLoginViewController *)controller;
@end
