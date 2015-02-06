//
//  YijianViewController.h
//  SUSHIDO
//
//  Created by liu song on 13-3-5.
//
//

#import <UIKit/UIKit.h>

@interface YijianViewController : UIViewController
{
    UITapGestureRecognizer *oneFingerTwoTaps;

    UITextView *textview;
    
    BOOL jianpan_sign;
}
@property (nonatomic, strong)IBOutlet UITextView *textview;


@end
