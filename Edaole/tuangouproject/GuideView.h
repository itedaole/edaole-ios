//
//  GuideView.h
//  tuangouproject
//
//  Created by stcui on 12/11/14.
//
//

#import <UIKit/UIKit.h>

@protocol GuideViewDelegate <NSObject>
- (void)onGuideGoPressed;
@end
@interface GuideView : UIView <UIScrollViewDelegate>
@property (weak, nonatomic) id<GuideViewDelegate>delegate;
@property (strong, nonatomic) UIScrollView *scrollView;
- (void)prepareForDealloc;
- (IBAction)onGo:(id)sender;
@end
