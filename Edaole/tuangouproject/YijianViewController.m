//
//  YijianViewController.m
//  SUSHIDO
//
//  Created by liu song on 13-3-5.
//
//

#import "YijianViewController.h"

@interface YijianViewController ()

@end

@implementation YijianViewController

@synthesize textview;

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
    
    jianpan_sign = YES;
    
    /*******手势*********/
    oneFingerTwoTaps =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchouttextfield)];
    
    // Set required taps and number of touches
    
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [self.textview addGestureRecognizer:oneFingerTwoTaps];
    /******************/
}

-(IBAction)commityijian
{
    [self.navigationController popViewControllerAnimated:YES];

}

//- (IBAction)touchintextfield
//{
//    //[self.textview becomeFirstResponder];
//    
//  
//    
//    /*******手势*********/
//    oneFingerTwoTaps =
//    [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchouttextfield)] autorelease];
//    
//    // Set required taps and number of touches
//    
//    [oneFingerTwoTaps setNumberOfTapsRequired:1];
//    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
//    
//    // Add the gesture to the view
//    [self.view addGestureRecognizer:oneFingerTwoTaps];
//    /******************/
//    
//   
//    
//}

-(void)touchouttextfield
{
//    if(jianpan_sign)
//    {
//        
//    
//    }
//    else
//    {
//        [self.textview resignFirstResponder];
//    
//        [self.textview  removeGestureRecognizer:oneFingerTwoTaps];
//    }
//    jianpan_sign=!jianpan_sign;
}

@end
