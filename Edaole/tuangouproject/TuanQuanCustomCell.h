

#import <UIKit/UIKit.h>


@interface TuanQuanCustomCell : UITableViewCell {
	UILabel    *nameLabel;
	UILabel    *boughtLabel;
	UILabel    *contentLabel;
    UIImageView *listimageview;
    UILabel    *price; 
    UILabel    *value;
    UILabel    *summary;
    
    
}
@property (nonatomic, strong) IBOutlet UILabel    *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel    *sellerLabel;
@property (nonatomic, strong) IBOutlet UILabel    *boughtLabel;
@property (nonatomic, strong) IBOutlet UILabel    *contentLabel;
@property (nonatomic, strong) IBOutlet UIImageView    *listimageview;
@property (nonatomic, strong) IBOutlet UILabel    *price;
@property (nonatomic, strong) IBOutlet UILabel    *value;
@property (nonatomic, strong) IBOutlet UILabel    *summary;


@end
