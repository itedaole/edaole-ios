//
//  BaseViewController.h
//  tuangouproject
//
//  Created by stcui on 14-1-1.
//
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@end

@interface UIViewController (Ext)
- (UIBarButtonItem *)backBarButtonItem;
- (IBAction)goBack:(id)sender;
@end
