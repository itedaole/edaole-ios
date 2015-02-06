//
//  TextField.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "TextField.h"

@implementation TextField
{
    UIImage *bg;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    bg = [[UIImage imageNamed:@"bg_login_inputView"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [bg drawInRect:self.bounds];
    [super drawRect:rect];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 0);
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 0);
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 0);
}

@end
