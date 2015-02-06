//
//  Annotation.m
//  tuangouproject
//
//  Created by cui on 13-5-30.
//
//

#import "Annotation.h"

@implementation Annotation
- (id)copyWithZone:(NSZone *)zone
{
    Annotation *a = [[Annotation allocWithZone:zone] init];
    a.coordinate = self.coordinate;
    a.title = self.title;
    a.subtitle = self.subtitle;
    a.product = self.product;
    return a;
}
@end
