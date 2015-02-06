//
//  TitleLabel.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "TitleLabel.h"

@implementation TitleLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0.6 alpha:1]set];
    CGContextSetAllowsAntialiasing(ctx, false);
    CGFloat lengths[] = {5,3};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextMoveToPoint(ctx, 0, CGRectGetHeight(self.bounds));
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGContextStrokePath(ctx);
    CGContextSetAllowsAntialiasing(ctx, true);
    [super drawRect:rect];
}

@end
