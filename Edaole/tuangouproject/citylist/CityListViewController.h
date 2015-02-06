//
//  CityListViewController.h
//  citylistdemo
//
//  Created by BW on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragRefreshViewController.h"

@interface CityListViewController : UIViewController {
    NSDictionary *cities;  
    NSArray *keys;
    id __unsafe_unretained delegate;
    UITableView *tbView;
    
    UINavigationBar *bar;
}
@property (nonatomic, strong) IBOutlet UITableView *tbView;
@property (nonatomic, strong) IBOutlet UINavigationBar *bar;

@property (nonatomic, strong) NSDictionary *cities;  
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, unsafe_unretained) id delegate;

- (IBAction)pressReturn:(id)sender;
- (void)findAndSelectCity:(NSString *)cityName;
@end

@protocol CityListViewControllerProtocol
- (void) citySelectionUpdate:(NSString*)selectedCity;
- (NSString*) getDefaultCity;
@end

