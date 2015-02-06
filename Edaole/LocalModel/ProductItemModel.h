//
//  ProductItemModel.h
//  tuangouproject
//
//  Created by Jinsongzhuang on 1/29/15.
//
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ProductItemModel : JSONModel

@property (assign, nonatomic) int id;
@property (nonatomic, assign) int user_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *title_local;

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *image1;
@property (nonatomic, copy) NSString *image2;

@end
