//
//  CatalogCell.m
//  tuangouproject
//
//  Created by stcui on 14-1-1.
//
//

#import "CatalogCell.h"

@implementation CatalogCell

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self configView];
}

- (void)configView
{
    CAGradientLayer *layer = (CAGradientLayer*)self.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithWhite:0.83 alpha:1].CGColor;
    layer.colors = @[(__bridge id)[UIColor colorWithWhite:0.95 alpha:1].CGColor,
                     (__bridge id)[UIColor colorWithWhite:0.9 alpha:1].CGColor];
    layer.locations = @[@0, @1];
    layer.startPoint = CGPointMake(0.5f, 0);
    layer.endPoint   = CGPointMake(0.5f, 1);
    UIFont *font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = font;
    [self setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    static CGFloat bottom = 20;
    CGRect f = self.bounds;
    f.size.height -= bottom;
    self.imageView.frame = f;
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIFont *font = self.titleLabel.font;
    self.titleLabel.frame = CGRectMake(0, self.bounds.size.height-bottom, self.bounds.size.width, font.lineHeight);
    self.titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
}

@end
