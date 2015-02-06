//
//  BaseTabController.h
//  
//
//  Created by Steven Choi on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabController : UIViewController  <UINavigationControllerDelegate>
@property (strong, nonatomic) UIView *tab;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (unsafe_unretained, nonatomic) UIViewController *selectedViewController;
- (CGRect)contentFrame;
@end
