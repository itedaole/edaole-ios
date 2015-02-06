

#import <UIKit/UIKit.h>


@interface ProductCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel    *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel    *boughtLabel;
@property (nonatomic, strong) IBOutlet UILabel    *contentLabel;
@property (nonatomic, strong) IBOutlet UIImageView    *listimageview;
@property (nonatomic, strong) IBOutlet UILabel    *unitLabel;
@property (nonatomic, strong) IBOutlet UILabel    *price;
@property (nonatomic, strong) IBOutlet UILabel    *value;
@property (nonatomic, strong) IBOutlet UILabel    *summary;
@property (strong, nonatomic) IBOutlet UIImageView *neuImage;
@property (strong, nonatomic) IBOutlet UIView *deleteLine;
@property (strong, nonatomic) IBOutlet UILabel *rangeLabel;
@end
