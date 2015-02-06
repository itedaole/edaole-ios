//
//  LeftAlignButton.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "LeftAlignButton.h"

@implementation LeftAlignButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.left = 15;
    self.titleLabel.left = self.imageView.right + 18;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
