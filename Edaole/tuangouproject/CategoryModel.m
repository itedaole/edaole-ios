//
//  CategoryModel.m
//  tuangouproject
//
//  Created by stcui on 14-2-23.
//
//

#import "CategoryModel.h"
#import "ASIHttpRequest.h"

@interface CategoryModel () <ASIHTTPRequestDelegate>
@property (strong, nonatomic) ASIHTTPRequest *req;
@end

@implementation CategoryModel
+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)dealloc
{
    [self.req cancel];
}
- (void)loadFromNetwork
{
    if (self.req) return;
    NSString *url = TGURL(@"Tuan/typeList", nil);
    
    NSLog(@"%@",url);
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    req.delegate = self;
    self.req = req;
    [req startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.error = nil;
    self.rootObject = [request.responseData objectFromJSONData][@"result"];
    
    NSDictionary *resp = [request.responseData objectFromJSONData];
    if ([[resp valueForKey:@"status"] integerValue] == 1) {
        NSArray *newCategories = [resp valueForKey:@"result"];
        if ([(NSArray *)self.rootObject count]) {
            if (! [[(NSArray *)self.rootObject subarrayWithRange:NSMakeRange(1, [(NSArray *)self.rootObject count] -1)] isEqualToArray:newCategories]) {
                //            self.rootObject = [newCategories mutableCopy];
//            [self.rootObject insertObject:@{@"id":[NSNull null], @"name":self.allItemName} atIndex:0];
            }
        }
    }
    self.req = nil;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.req = nil;
    self.error = request.error = nil;
}

@end
