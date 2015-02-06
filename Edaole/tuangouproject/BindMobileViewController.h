//
//  BindMobileViewController.h
//  tuangouproject
//
//  Created by  na on .
//
//

#import <UIKit/UIKit.h>
#import "TextField.h"

@protocol BindMobileViewControllerDelegate;

@interface BindMobileViewController : UIViewController
@property (nonatomic) id<BindMobileViewControllerDelegate> delegate;
@property (unsafe_unretained, nonatomic) IBOutlet TextField *textField;
@property (nonatomic) BOOL inputOnly;
@end

@protocol BindMobileViewControllerDelegate <NSObject>
- (void)bindController:(BindMobileViewController *)c enterCode:(NSString *)code;
@end
