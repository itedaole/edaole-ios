//
//  SearchViewController.h
//  tuangouproject
//
//  Created by liu song on 13-3-5.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
{

    UINavigationBar *bar;
    UISearchBar *searchBar;
}

@property (nonatomic, strong) IBOutlet UINavigationBar *bar;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;

@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (nonatomic) BOOL loading;
@end
