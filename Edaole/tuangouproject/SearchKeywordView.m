//
//  SearhKeywordView.m
//  tuangouproject
//
//  Created by stcui on 14-3-26.
//
//

#import "SearchKeywordView.h"
static const CGFloat kSpacing = 3;
static const CGFloat kCellHeight = 33;
@implementation SearchKeywordView
{
    UIEdgeInsets _insets;
    struct {
        uint delegateRespondsToTapEvent : 1;
    } _flags;
}
- (id)initWithFrame:(CGRect)frame edgeInsets:(UIEdgeInsets)insets
{
    self = [super initWithFrame:frame];
    if (self) {
        _insets = insets;
    }
    return self;
}

- (void)setKeywords:(NSArray *)keywords
{
    if (_keywords == keywords) return;
    _keywords = keywords;
    [self fillViewWithKeywords];
}

- (void)fillViewWithKeywords
{
    NSUInteger count = self.keywords.count;
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        if (idx < count) {
            btn.hidden = NO;
            [btn setTitle:self.keywords[idx] forState:UIControlStateNormal];
        } else {
            btn.hidden = YES;
        }
    }];
    for (NSInteger i = self.subviews.count; i < count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderWidth = 1;
        [btn setTitleColor:[UIColor colorWithWhite:0.33 alpha:1] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        btn.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        btn.layer.cornerRadius = 5.0f;
        [btn setTitle:self.keywords[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onTapKeyword:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    CGFloat width = roundf(([UIScreen mainScreen].bounds.size.width - 2 * kSpacing - _insets.left - _insets.right)/ 3);
    CGRect frame = CGRectMake(_insets.left, _insets.top, width, kCellHeight);

    for (UIView *view in self.subviews) {
        view.frame = frame;
        frame.origin.x += (width+kSpacing);
        if (CGRectGetMaxX(frame) > CGRectGetWidth(self.bounds) - kSpacing) {
            frame.origin.x = _insets.left;
            frame.origin.y += (kCellHeight + kSpacing);
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    NSUInteger count = ceilf(self.keywords.count / 3.0);
    return CGSizeMake(self.width, count * kCellHeight + kSpacing * (count-1) + _insets.top + _insets.bottom);
}

- (void)setDelegate:(id<SearchKeywordViewDelegate>)delegate
{
    _delegate = delegate;
    _flags.delegateRespondsToTapEvent = [delegate respondsToSelector:@selector(searchKeywordView:didSelectKeyword:)];
}

- (void)onTapKeyword:(UIButton *)button
{
    if (_flags.delegateRespondsToTapEvent) {
        [self.delegate searchKeywordView:self didSelectKeyword:[button titleForState:UIControlStateNormal]];
    }
}
@end
