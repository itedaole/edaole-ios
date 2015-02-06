//
//  LoadingFooter.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "LoadingFooter.h"


@implementation LoadingFooter

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.hidesWhenStopped = YES;
        self.clipsToBounds = NO;
        [self addSubview:_indicator];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _indicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}
- (void)setLoading:(BOOL)loading
{
    loading ? [_indicator startAnimating] : [_indicator stopAnimating];
}
@end
