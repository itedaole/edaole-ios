//
//  ViewController.h
//  QR code
//
//  Created by 斌 on 12-8-2.
//  Copyright (c) 2012年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @class CodeViewController
 团购券二维码生成
 */

@interface CodeViewController : UIViewController<UIAlertViewDelegate >
{
    NSString *shopname;

    NSString *shopname_down;
    
    
    IBOutlet UILabel *up;
    IBOutlet UILabel *down;
}
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UIImageView *codeBg;
@property (strong, nonatomic) IBOutlet UIImage *codeBgImage;
@property (strong, nonatomic) IBOutlet UIImageView *imageview_down;
@property (strong, nonatomic) IBOutlet UILabel *text;

@property (strong, nonatomic) NSString *shopname;
@property (strong, nonatomic) NSString *shopname_down;

//- (IBAction)button:(id)sender;
- (IBAction)button2:(id)sender;
- (IBAction)Responder:(id)sender;

- (void)consumed:(BOOL)consumed;
@end
