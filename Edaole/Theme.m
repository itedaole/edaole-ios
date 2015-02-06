//
//  Theme.m
//  tuangouproject
//
//  Created by cui on 13-6-6.
//
//

#import "Theme.h"
#import <objc/runtime.h>

static NSString * __bundleName = nil;
static NSDictionary *__colorTable = nil;
@implementation Theme
+ (void)setBundleName:(NSString *)bundleName
{
    __bundleName = bundleName;
    NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    NSString *colorTablePath = [NSString stringWithFormat:@"%@/color.json", path];
    NSData *data = [NSData dataWithContentsOfFile: colorTablePath];
    __colorTable = [data objectFromJSONData];
}

+ (NSString *)bundleName
{
    return __bundleName;
}

@end

@implementation UIImage (Theme)
+ (void)load
{
    @autoreleasepool {
//        Method oldMethod = class_getClassMethod(self, @selector(imageNamed:));
//        Method newMethod = class_getClassMethod(self, @selector(_imageNamed:));
//        method_exchangeImplementations(oldMethod, newMethod);
    }
}

+ (UIImage *)_imageNamed:(NSString *)name
{
    NSString * nameWithBundle = [[Theme bundleName] stringByAppendingFormat:@".bundle/%@", name];
    UIImage *image = [self _imageNamed:nameWithBundle];
    if (nil == image) {
       image = [self _imageNamed:name];
    }
    return image;
}
@end

@implementation UIColor (DynamicThemeMethod)

static UIColor *colorBySelector(id self, SEL cmd) {
    NSString *methodName = NSStringFromSelector(cmd);
    NSString *name = [NSStringFromSelector(cmd) stringByReplacingOccurrencesOfString:@"Color$" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, methodName.length)];
    NSString *str = __colorTable[name];
    if (!str) {
        return nil;
    }
    float r,g,b,a;
    sscanf([str UTF8String], "%f,%f,%f,%f", &r, &g, &b, &a);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    NSString *methodName = NSStringFromSelector(sel);
    if ([methodName hasSuffix:@"Color"]) {
        Class metaClass = class_getSuperclass(self);
        class_addMethod(metaClass, sel, (IMP)colorBySelector, "@:v");
        return YES;
    }
    return YES;
}

+ (instancetype)tabSelectionTintColor
{
    return [UIColor colorWithRed:246/255.0 green:40/255.0 blue:40/255.0 alpha:1];
}
@end

@implementation UIView (Theme)
+ (instancetype)cellBackground
{
    if ([[Theme bundleName] isEqualToString:@"blue"]) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        v.backgroundColor = [UIColor colorWithRed:0.40f green:0.76f blue:0.89f alpha:1.00f];
        return v;
    } else {
        return [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hang_xz.png"]];
    }         
}
@end

@implementation UIButton (Theme)
+ (instancetype)cancelButtonWithTarget:(id)target action:(SEL)action
{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    /*
    [button setBackground:@"bar_button" highlight:@"bar_button_hilight"];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.size = CGSizeMake(50, 30);
     */
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    [button setBackground:@"btn_dismissItem" highlight:@"btn_dismissItem_highlighted"];
    [button setSize:CGSizeMake(19, 19)];
    return button;
}
@end
