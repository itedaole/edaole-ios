//
//  WeiChatShareView.h
//  tuangouproject
//
//  Created by Jinsongzhuang on 1/26/15.
//
//

#import <UIKit/UIKit.h>

@interface WeiChatShareView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextView *productNotesTextView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLable;

@end
