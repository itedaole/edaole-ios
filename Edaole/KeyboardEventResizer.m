//
//  SWKeyboardEventResizer.m
//
//  Created by  na on .
//
//

#import "KeyboardEventResizer.h"

@implementation KeyboardEventResizer
- (id)initWithContentView:(UIView *)contentView
{
    self = [super init];
    if (self) {
        self.contentView = contentView;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    if (!self.contentView.superview) return;
    
    CGFloat duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    UIView *superview = self.contentView.superview;
    CGRect keyboardF = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardF = [superview convertRect:keyboardF fromView:nil];
    CGRect contentF = superview.bounds;
    contentF.size.height = CGRectGetMinY(keyboardF);
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.contentView.frame = contentF;
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    if (!self.contentView.superview) return;
    
    CGFloat duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:duration
                     animations:^{
                         self.contentView.frame = self.contentView.superview.bounds;
                     }];
}

@end
