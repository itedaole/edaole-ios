//
//  AsyncModel.h
//  tuangouproject
//
//  Created by stcui on 14-2-23.
//
//

#import <Foundation/Foundation.h>

@interface AsyncModel : NSObject
@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) id <NSCoding> rootObject;
- (void)saveToDisk;
- (void)loadFromDisk;
- (void)loadFromNetwork;
@end
