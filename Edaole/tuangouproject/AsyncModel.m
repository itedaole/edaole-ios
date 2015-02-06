//
//  AsyncModel.m
//  tuangouproject
//
//  Created by stcui on 14-2-23.
//
//

#import "AsyncModel.h"
#import "JSONKit.h"

static NSString *documentPath () {
    static NSString *result = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    });
    return result;
}

@implementation AsyncModel
{
    dispatch_queue_t _ioQueue;
}

- (id)init
{
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create("com.tg.async_model.io", DISPATCH_QUEUE_CONCURRENT);
        [self loadFromDisk];
    }
    return self;
}

- (void)loadFromNetwork
{
    
}

- (void)saveToDisk
{
    NSString *filename = [NSStringFromClass(self.class) stringByAppendingString:@".am"];
    dispatch_async(_ioQueue, ^{
        if (self.rootObject) {
            NSData *data = [(id)self.rootObject JSONData];
            BOOL success = [data writeToFile:[documentPath() stringByAppendingPathComponent: filename] atomically:YES];
            if (!success) {
                NSLog(@"save failed");
            }
        }
    });
}

- (void)loadFromDisk
{
    NSString *filename = [NSStringFromClass(self.class) stringByAppendingString:@".am"];
    NSData *data = [NSData dataWithContentsOfFile:[documentPath() stringByAppendingPathComponent: filename]];
    self.rootObject = [data objectFromJSONData];
}

@end
