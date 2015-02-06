//
//  ProfileViewController.h
//  tuangouproject
//
//  Created by stcui on 14-1-1.
//
//

#import <UIKit/UIKit.h>
#import "DragRefreshViewController.h"
#import "SpacingButton.h"

@interface ProfileViewController : DragRefreshViewController <UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *infoHeaderView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet SpacingButton *myCouponsButton;
@property (assign, nonatomic) BOOL enabled;

- (IBAction)onShowCoupons:(id)sender;
@end
