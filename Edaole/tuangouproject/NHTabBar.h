//
//  NHTabBar.h
//  
//
//  Created by stcui on 12-2-8.
//  Copyright (c) 2012年 stcui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHTabBar : UIControl
@property (nonatomic, strong) NSArray *tabs;
@property (nonatomic) NSInteger selectedIndex;
- (void)showBadgetAtIndex:(NSInteger)index;
@end
