//
//  LoadingFooter.h
//  tuangouproject
//
//  Created by  na on .
//
//

#import <UIKit/UIKit.h>


@interface LoadingFooter : UIView
{
    UIActivityIndicatorView *_indicator;
}
- (void)setLoading:(BOOL)loading;
@end