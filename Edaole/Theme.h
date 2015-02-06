//
//  Theme.h
//  tuangouproject
//
//  Created by cui on 13-6-6.
//
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject
+ (NSString *)bundleName;
+ (void)setBundleName:(NSString *)bundleName;
@end

@interface UIColor (Theme)
+ (instancetype)barTintColor;
+ (instancetype)tabSelectionTintColor;
+ (instancetype)refreshTintColor;
+ (instancetype)priceColor;
@end

@interface UIView (Theme)
+ (instancetype)cellBackground;
@end

@interface UIButton (Theme)
+ (instancetype)cancelButtonWithTarget:(id)target action:(SEL)action;
@end
