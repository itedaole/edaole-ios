//
//  BaseViewController.m
//  tuangouproject
//
//  Created by stcui on 14-1-1.
//
//

#import "BaseViewController.h"
#import <objc/runtime.h>
#import "UIBarButtonItem+Factory.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

static char kBackButtonKey;
@implementation UIViewController (Ext)
- (UIBarButtonItem *)backBarButtonItem
{
    UIBarButtonItem *item = objc_getAssociatedObject(self, &kBackButtonKey);
    if (!item) {
        item = [UIBarButtonItem backItemWithTarget:self action:@selector(goBack:)];
        objc_setAssociatedObject(self, &kBackButtonKey, item, OBJC_ASSOCIATION_RETAIN);
    }
    return item;
}

- (IBAction)goBack:(id)sender
{
    if (self.navigationController && self.navigationController.viewControllers[0] != self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
