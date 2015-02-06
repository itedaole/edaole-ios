//
//  AboutViewController.h
//  SUSHIDO
//
//  Created by song liu on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"


@interface AboutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableView;

    NSMutableArray *namearray;
    NSMutableArray *namearray2;
    NSMutableArray *namearray3;
    
    
    LoginViewController *logincontroller;
}
@property (nonatomic, strong)  LoginViewController *logincontroller;
@end
