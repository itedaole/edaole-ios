//
//  MyOwnCouponCell.m
//  tuangouproject
//
//  Created by Jinsongzhuang on 1/29/15.
//
//

#import "MyOwnCouponCell.h"
#import "UIImageView+WebCache.h"

@implementation MyOwnCouponCell
{
    __weak IBOutlet UIImageView *_productImageView;
    __weak IBOutlet UILabel *_titleLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellInfoWithModel:(ProductItemModel *)productModel
{
    _titleLabel.text = productModel.title;
    
    NSString *imageURL = [NSString stringWithFormat:@"http://www.edaole.com/static/%@",productModel.image];
    
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
