//
//  CategoryView.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "CategoryView.h"

@implementation CategoryView

- (UIButton *)button
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    return btn;
}

- (void)setup
{
    _categoryButton = [self button];
    [_categoryButton setTitle:@"分类" forState:UIControlStateNormal];
    [_categoryButton setImage:[UIImage imageNamed:@"btn_quanbu"] forState:UIControlStateNormal];

    _sortButton = [self button];
    [_sortButton setTitle:@"排序" forState:UIControlStateNormal];
    [_sortButton setImage:[UIImage imageNamed:@"btn_paixu"] forState:UIControlStateNormal];
    [self addSubview:_categoryButton];
    [self addSubview:_sortButton];
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
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat width = CGRectGetMidX(self.bounds);
    CGRect f = self.bounds;
    f.size.width = width;
    self.categoryButton.frame = f;
    f.origin.x += width;
    self.sortButton.frame = f;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [[UIImage imageNamed:@"btn_catalog"] drawInRect:self.bounds];
    CGFloat x = CGRectGetMidX(self.bounds);
    [[UIColor colorWithWhite:0.75 alpha:1] set];
    UIRectFill(CGRectMake(x, 0, 1, CGRectGetHeight(self.bounds)));
    CGContextStrokeRect(UIGraphicsGetCurrentContext(), self.bounds);
}


@end
