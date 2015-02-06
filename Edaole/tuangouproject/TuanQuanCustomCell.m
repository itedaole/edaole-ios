

#import "TuanQuanCustomCell.h"


@implementation TuanQuanCustomCell
@synthesize nameLabel;
@synthesize boughtLabel;
@synthesize contentLabel;
@synthesize listimageview;
@synthesize price;
@synthesize value;
@synthesize summary;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.nameLabel.text = nil;
    self.sellerLabel.text = nil;
    self.listimageview.image = nil;
    self.value.text = nil;
}

@end
