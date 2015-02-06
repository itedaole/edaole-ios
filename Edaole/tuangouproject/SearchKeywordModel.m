//
//  SearchKeyworkModel.m
//  tuangouproject
//
//  Created by stcui on 14-3-26.
//
//

#import "SearchKeywordModel.h"
#import "ASIHTTPRequest.h"

@interface SearchKeywordModel () <ASIHTTPRequestDelegate>

@end

@implementation SearchKeywordModel
{
    ASIHTTPRequest *_req;
}
IMP_SINGLETON
- (void)loadFromNetwork
{
    if (_req) return;
    NSURL *url = [NSURL URLWithString: TGURL(@"Tuan/hotKeys", nil)];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    req.delegate = self;
    _req = req;
    [req startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dict = [request.responseData objectFromJSONData];
    if (dict) {
        self.rootObject = dict[@"result"];
    }
    _req = nil;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    _req = nil;
}

@end
