//
//  MediaPlayerViewController.h
//  tuangouproject
//
//  Created by stcui on 11/27/14.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MediaPlayerFinishType) {
    MediaPlayerFinishTypeSkip,
    MediaPlayerFinishTypeRegister,
    MediaPlayerFinishTypeLogin
};

@interface MediaPlayerViewController : UIViewController
@property (copy, nonatomic) void(^onFinish)(MediaPlayerViewController *player,MediaPlayerFinishType type);
- (instancetype)initWithContentURL:(NSURL *)url;
- (void)play;
@end
