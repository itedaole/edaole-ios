//
//  RegisterController.h
//  tuangouproject
//
//  Created by liu song on 13-3-7.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterController : UIViewController
{

     UINavigationBar *bar;
    
    UITapGestureRecognizer *oneFingerTwoTaps;
    
    IBOutlet UITextField *telname;
    IBOutlet UITextField *telname1;
    IBOutlet UITextField *telname2;
    IBOutlet UITextField *telname3;
    IBOutlet UITextField *telname4;
}
@property (nonatomic, copy) void(^registerCompletion)(BOOL succeed);
@property (nonatomic, strong) IBOutlet UINavigationBar *bar;
@property (nonatomic, strong) UITextField *telname;
@property (nonatomic, strong) UITextField *telname1;
@property (nonatomic, strong) UITextField *telname2;
@property (nonatomic, strong) UITextField *telname3;
@property (nonatomic, strong) UITextField *telname4;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *confirmButton;


@end

@protocol RegisterController <NSObject>
@optional
- (void)registerControllerSuccess:(RegisterController *)controller;
@end
