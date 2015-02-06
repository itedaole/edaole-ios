//
//  UIViewController+ioshack.h
//  tuangouproject
//
//  Created by iBcker on 13-12-24.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (ioshack)
- (UIRectEdge)edgesForExtendedLayout;
- (void)setEdgesForExtendedLayout:(UIRectEdge)rect;
@end
