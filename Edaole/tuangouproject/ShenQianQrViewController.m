//
//  ShenQianQrViewController.m
//  tuangouproject
//
//  Created by iBcker on 14-5-17.
//
//

#import "ShenQianQrViewController.h"

@interface ShenQianQrViewController ()

@end

@implementation ShenQianQrViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor=[UIColor whiteColor];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClose:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
@end
