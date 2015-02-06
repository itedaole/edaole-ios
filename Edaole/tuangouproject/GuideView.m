//
//  GuideTextView.m
//  tuangouproject
//
//  Created by stcui on 12/11/14.
//
//

#import "GuideView.h"

@implementation GuideView
{
    UIView *_contentView;
    UIPageControl *_pageControl;
    NSTimer *_timer;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    
    UINib *nib = [UINib nibWithNibName:@"GuideView" bundle:nil];
    _contentView = [[nib instantiateWithOwner:self options:nil] lastObject];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.bottom = CGRectGetMaxY(scrollView.bounds) - 30;
    [scrollView addSubview:_contentView];
    scrollView.contentSize = _contentView.frame.size;
    _scrollView = scrollView;
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = 5;
    [_pageControl sizeToFit];
    [self addSubview:_pageControl];
    _pageControl.centerX = CGRectGetMidX(self.bounds);
    _pageControl.bottom = CGRectGetMaxY(self.bounds);
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(onAutoPagingTimer:) userInfo:nil repeats:YES];
}

- (void)onAutoPagingTimer:(NSTimer *)timer
{
    NSInteger page = (_pageControl.currentPage + 1) % 5;
    if (page == 0) return;
    CGFloat offset = self.scrollView.frame.size.width * page;
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)prepareForDealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger page = roundf( scrollView.contentOffset.x  /  scrollView.frame.size.width);
    _pageControl.currentPage = page;
}
- (IBAction)onGo:(id)sender
{
    [self.delegate onGuideGoPressed];
}
@end
