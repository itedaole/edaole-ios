//
//  MyCouponListModel.h
//  tuangouproject
//
//  Created by Jinsongzhuang on 1/29/15.
//
//

#import <Foundation/Foundation.h>
#import "ProductItemModel.h"

@protocol ProductItemModel;

@interface MyCouponListModel : JSONModel

@property (nonatomic, assign) int status;

@property (nonatomic, strong) NSArray <ProductItemModel> *result;

@end
