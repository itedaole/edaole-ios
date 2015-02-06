

#import "ProductCell.h"
#import "Theme.h"

@implementation ProductCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
//        self.unitLabel.textColor = [UIColor priceColor];
//        self.price.textColor = [UIColor priceColor];
//    }
//    return self;
//}

//- (void)awakeFromNib
//{
//    //[super awakeFromNib];
//    self.unitLabel.textColor = [UIColor priceColor];
//    self.price.textColor = [UIColor priceColor];
//    self.neuImage.image = [UIImage imageNamed:@"deal_flag_new"];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self.price sizeToFit];
//    self.value.left = self.price.right + 5;
//    [self.value sizeToFit];
//    self.deleteLine.width = self.value.width+2;
//    self.deleteLine.left = self.value.left - 1;
//    [self.rangeLabel sizeToFit];
//    [self.boughtLabel sizeToFit];
//    self.boughtLabel.right = self.contentView.width - 8;
//    self.rangeLabel.right = self.boughtLabel.left-3;
//    self.rangeLabel.top = self.boughtLabel.top;
//}



@end
