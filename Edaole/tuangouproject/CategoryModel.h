//
//  CategoryModel.h
//  tuangouproject
//
//  Created by stcui on 14-2-23.
//
//

#import <Foundation/Foundation.h>
#import "AsyncModel.h"

@interface CategoryModel : AsyncModel
+ (instancetype)sharedInstance;
@property (strong, nonatomic) NSArray *rootObject;
@end
