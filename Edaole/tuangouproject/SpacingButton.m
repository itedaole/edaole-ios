//
//  SpacingButton.m
//  tuangouproject
//
//  Created by stcui on 14-1-11.
//
//

#import "SpacingButton.h"

@implementation SpacingButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize s = size;
    s.width += self.spacing;
    return s;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGFloat spacing = self.spacing / 2;
//    self.imageView.left -= spacing;
//    self.titleLabel.left += spacing;
//}
//
//
@end
