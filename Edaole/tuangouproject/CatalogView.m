//
//  CatalogView.m
//  tuangouproject
//
//  Created by stcui on 14-1-1.
//
//

#import "CatalogView.h"

@implementation CatalogView
{
    CGFloat _desiredHeight;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _desiredHeight = CGRectGetHeight(frame);
    }
    return self;
}

- (void)awakeFromNib
{
    _desiredHeight = CGRectGetHeight(self.frame);
    [self configView];
}

- (void)configView
{
    for (UIButton *btn in self.subviews) {
        [btn addTarget:self action:@selector(didSelectCell:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (IBAction)didSelectCell:(UIControl *)cell
{
    NSInteger index = cell.tag - 1;
    NSArray *item = self.items[index];
    [self.delegate catalogView:self didItem:item index:index];
}

- (void)setItems:(NSArray *)items
{
    //self.backgroundColor = [UIColor redColor];
    
    NSArray *subviews = self.subviews;
    NSInteger count = items.count;
    [subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        if (idx < count) {
            btn.hidden = NO;
            NSArray *item = items[idx];
            [btn setImage:item[0] forState:UIControlStateNormal];
            [btn setTitle:item[1] forState:UIControlStateNormal];
        } else {
            btn.hidden = YES;
        }
    }];
    CGFloat height = count <= 4 ? _desiredHeight / 2 : _desiredHeight;
    self.height = height;
}
@end
