//
//  UIBarButtonItem+Factory.h
//  tuangouproject
//
//  Created by cui on 13-6-1.
//
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Factory)
+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)backItemWithTarget:(id)target action:(SEL)action;
@end
